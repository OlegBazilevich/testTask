
import UIKit
import SnapKit
import Kingfisher

final class MovieTableViewCell: UITableViewCell {
    
    static let identifier = "MovieTableViewCell"
    
    private lazy var posterImageView: UIImageView = build {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    private func buildLabel(text: String) -> UILabel {
        return build {
            $0.font = Constants.Fonts.semibold
            $0.textAlignment = .center
            $0.text = text
            $0.textColor = .white
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            $0.layer.cornerRadius = 5
            $0.numberOfLines = 0
            $0.layer.masksToBounds = true
        }
    }

    private lazy var title: UILabel = buildLabel(text: Constants.noData)
    private lazy var releaseDateLabel: UILabel = buildLabel(text: Constants.noData)
    private lazy var voteAverageLabel: UILabel = buildLabel(text: Constants.noData)
    private lazy var genresLabel: UILabel = buildLabel(text: Constants.noData)
   
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func configure(_ viewModel: MovieTableViewCellViewModel) {
        
        if let posterURL = viewModel.posterPath {
            let moviePosterImageURL = URL(string: APIConstants.imageBaseURL + posterURL)
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(with: moviePosterImageURL)
        }
        
        title.text = viewModel.movieTitle
        
        if let releaseDate = viewModel.releaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let date = dateFormatter.date(from: releaseDate) {
                let yearFormatter = DateFormatter()
                yearFormatter.dateFormat = "yyyy"
                let yearString = yearFormatter.string(from: date)
                releaseDateLabel.text = yearString
            } else {
                releaseDateLabel.text = "Invalid Date"
            }
        } else {
            releaseDateLabel.text = "N/A"
        }
        
        if let avarage = viewModel.voteAverage {
            let roundedAvarage = Double(round(10 * avarage) / 10)
            voteAverageLabel.text = "📈 \(roundedAvarage)"
        }
        
        genresLabel.text = "\(configureGenres(viewModel).minimalDescription)"
    }
    
    private func configureGenres(_ viewModel: MovieTableViewCellViewModel) -> [String] {
        var apiGenreNames: [String] = []
        let genresList = OfflineGenresModel.GenresList
        
        for list in genresList {
            for response in viewModel.genreIds ?? [Int]() {
                if response == list.id {
                    apiGenreNames.append(list.name ?? "")
                }
            }
        }
        
        return apiGenreNames.map { $0.localized() }
    }
    
    private func setupConstraints() {
        contentView.makeShadow()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15))
        contentView.addSubview(posterImageView)
        
        posterImageView.addSubview(title)
        posterImageView.addSubview(releaseDateLabel)
        posterImageView.addSubview(genresLabel)
        posterImageView.addSubview(voteAverageLabel)
        
        
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        title.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(10)
        }
        
        releaseDateLabel.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(10)
        }
        
        voteAverageLabel.snp.makeConstraints {
            $0.top.equalTo(releaseDateLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(10)
        }
        
        genresLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
}
    

        
        
       
        
    
    

    

