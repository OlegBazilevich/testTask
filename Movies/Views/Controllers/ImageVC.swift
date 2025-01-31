
import UIKit

final class ImageVC: UIViewController, UIScrollViewDelegate {
    
    private lazy var scrollView: UIScrollView = build {
        $0.delegate = self
        $0.minimumZoomScale = 1.0
        $0.maximumZoomScale = 30.0
        $0.frame = view.bounds
    }
    
    private lazy var poster: UIImageView = build {
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true
    }
    
    init(movieImage: UIImageView) {
        super.init(nibName: nil, bundle: nil)
        self.poster.image = movieImage.image
    }
    
    private lazy var closeButton: UIButton = build {
        $0.setTitle("Close", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(poster)

        if let image = poster.image {
            let imageSize = image.size
            let scrollViewSize = scrollView.bounds.size

            // Calculate the initial scale to fit the image inside the scrollView
            let widthScale = scrollViewSize.width / imageSize.width
            let heightScale = scrollViewSize.height / imageSize.height
            let initialScale = min(widthScale, heightScale)

            // Set the poster's frame according to the image size
            poster.frame = CGRect(origin: .zero, size: imageSize)
            scrollView.contentSize = imageSize

            // Set the initial zoom scale
            scrollView.minimumZoomScale = initialScale
            scrollView.zoomScale = initialScale

            centerImageInScrollView()
        }
    }

    
    private func centerImageInScrollView() {
        let scrollViewSize = scrollView.bounds.size
        let imageSize = poster.frame.size
        
        let horizontalInset = max((scrollViewSize.width - imageSize.width) / 2, 0)
        let verticalInset = max((scrollViewSize.height - imageSize.height) / 2, 0)
        
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
    
    private func setupConstraints() {
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(15)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return poster
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1.0 {
            closeButton.setTitleColor(.systemBlue, for: .normal)
            closeButton.backgroundColor = .systemGray5
            closeButton.layer.cornerRadius = 5
        } else {
            closeButton.setTitleColor(.systemBlue, for: .normal)
            closeButton.backgroundColor = .clear
        }
    }
    
}
