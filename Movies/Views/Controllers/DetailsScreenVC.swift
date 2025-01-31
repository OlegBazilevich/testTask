
import UIKit
import Kingfisher
import YouTubeiOSPlayerHelper

final class DetailsScreenVC: UIViewController, UIGestureRecognizerDelegate {
    
    private var movieID: Int?
    
    init(movieID: Int?) {
        self.movieID = movieID
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var scrollView: UIScrollView = build {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var contentStackView: UIStackView = build { $0.axis = .vertical }
    private lazy var countryAndReleaseDateStackView: UIStackView = build { $0.axis = .horizontal }
    
    private lazy var flexibleSpacer: UIView = build {
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private lazy var buttonAndRatingStackView: UIStackView = build { $0.axis = .horizontal }
    private lazy var posterImageView: UIImageView = build { $0.contentMode = .scaleAspectFill }
   
    private lazy var mainTitle: UILabel = build {
        $0.numberOfLines = 0
        $0.font = Constants.Fonts.semibold
    }
    
    private lazy var releaseDateLabel: UILabel = build { $0.font = Constants.Fonts.semibold }
    
    private lazy var genresLabel: UILabel = build {
        $0.font = Constants.Fonts.semibold
        $0.numberOfLines = 0
    }
    
    private lazy var averageVote: UILabel = build { $0.font = Constants.Fonts.semibold }
    private lazy var mainDescription: UILabel = build {
        $0.font = Constants.Fonts.light
        $0.numberOfLines = 0
    }
    
    private lazy var playButton: UIButton = build {
        $0.setTitle("▶️", for: .normal)
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        $0.isHidden = true
    }
    
    @objc private func playButtonTapped() {
        loadVideo()
    }
    
    private func loadVideo() {
        guard let movieID = movieID else { return }
        
        RestService.shared.getMovieVideos(movieID: movieID) { [weak self] results in
            guard let self = self else { return }  // Safely unwrap 'self' here
            
            switch results {
            case .success(let videos):
                guard let videoId = videos.first?.key else { return }
                let videoPlayerVC = VideoPlayerVC(videoID: videoId)
                self.navigationController?.pushViewController(videoPlayerVC, animated: true)
                
            case .failure(let error):
                MyAlertManager.shared.showErrorAlert(error.localizedDescription, controller: self)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationMenu()
        getMovieDetail()
        addGesture()
        setupConstraints()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func navigationMenu() {
        if let movieID = movieID {
            RestService.shared.getMoviewDetail(
                movieID: movieID,
                language: APIConstants.currentAppLanguageID
            ) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let movie):
                    // Set the title from the movie model
                    self.navigationItem.title = movie.title
                case .failure(let error):
                    MyAlertManager.shared.showErrorAlert(error.localizedDescription, controller: self)
                }
            }
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getMovieDetail() {
        guard let movieID = movieID else { return }
        
        RestService.shared.getMoviewDetail(
            movieID: movieID,
            language: APIConstants.currentAppLanguageID
        ) { [weak self] result in
            guard let self = self else { return }
            
            ActivityIndicatorView.shared.presentedIndicator()
            
            switch result {
            case .success(let movie):
                self.configureContent(movieModel: movie)
                DispatchQueue.main.async {
                    ActivityIndicatorView.shared.hiddenIndicator()
                }
            case .failure(let error):
                ActivityIndicatorView.shared.hiddenIndicator()
                MyAlertManager.shared.showErrorAlert(error.localizedDescription, controller: self)
            }
        }
    }
    
    private func configureContent(movieModel: MovieDetailsModel?) {
        if let posterURL = movieModel?.backdropPath {
            let moviePosterImageURL = URL(string: APIConstants.imageBaseURL + posterURL)
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(with: moviePosterImageURL)
        }
        
        if let avarage = movieModel?.voteAverage {
            let roundedAvarage = Double(round(10 * avarage) / 10)
            averageVote.text = "📈 \(roundedAvarage)"
        }
        
        mainTitle.text = movieModel?.title
        
        if let releaseDate = movieModel?.releaseDate, let countryName = movieModel?.productionCountries?.first?.name {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let date = dateFormatter.date(from: releaseDate) {
                let yearFormatter = DateFormatter()
                yearFormatter.dateFormat = "yyyy"
                let yearString = yearFormatter.string(from: date)
                releaseDateLabel.text = "\(countryName), \(yearString)"
            } else {
                releaseDateLabel.text = "\(countryName), \(releaseDate)"
            }
        } else {
            releaseDateLabel.text = "N/A"
        }
        
        genresLabel.text = "\(configureGenres(movieModel).minimalDescription)"
        mainDescription.text = movieModel?.overview
        checkVideoAvailability(movieID: movieModel?.id ?? 0)
    }
    
    // Check if there is any available video and show the play button
    private func checkVideoAvailability(movieID: Int) {
        RestService.shared.getMovieVideos(movieID: movieID) { [weak self] result in
            switch result {
            case .success(let videos):
                self?.playButton.isHidden = videos.isEmpty
            case .failure:
                self?.playButton.isHidden = true
            }
        }
    }
    
    private func configureGenres(_ movieModel: MovieDetailsModel?) -> [String] {
        var apiGenreNames: [String] = []
        let genres = movieModel?.genres ?? [GenresModel]()
        
        for genre in genres {
            apiGenreNames.append(genre.name ?? "")
        }
        
        return apiGenreNames.map { $0.localized() }
    }
    
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gesturePoster))
        posterImageView.addGestureRecognizer(tapGesture)
        posterImageView.isUserInteractionEnabled = true
    }
    
    @objc private func gesturePoster(_ gesture: UITapGestureRecognizer) {
        let imageVC = ImageVC(movieImage: posterImageView)
        imageVC.modalPresentationStyle = .formSheet
        present(imageVC, animated: true)
    }
    
    private func setupConstraints() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(releaseDateLabel)
        contentStackView.addArrangedSubview(buttonAndRatingStackView)
        
        buttonAndRatingStackView.addArrangedSubview(playButton)
        buttonAndRatingStackView.addArrangedSubview(flexibleSpacer)
        buttonAndRatingStackView.addArrangedSubview(averageVote)
        
        [posterImageView, mainTitle, releaseDateLabel, genresLabel, buttonAndRatingStackView, mainDescription]
            .forEach { contentStackView.addArrangedSubview($0) }
        
        contentStackView.setCustomSpacing(15, after: posterImageView)
        contentStackView.setCustomSpacing(15, after: mainTitle)
        contentStackView.setCustomSpacing(15, after: releaseDateLabel)
        contentStackView.setCustomSpacing(15, after: genresLabel)
        contentStackView.setCustomSpacing(20, after: buttonAndRatingStackView)
        contentStackView.setCustomSpacing(20, after: mainDescription)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.edges.width.equalToSuperview().inset(15)
        }
        
        posterImageView.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.width)
            $0.leading.trailing.equalToSuperview()
        }
        
        playButton.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(50)
        }
    }
    

}
