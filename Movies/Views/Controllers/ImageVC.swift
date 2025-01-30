
//import UIKit
//
//final class ImageViewController: UIViewController {
//
//    private lazy var movieImage: UIImageView = build {
//        $0.contentMode = .scaleAspectFit
//    }
//
//    init(movieImage: UIImageView) {
//        super.init(nibName: nil, bundle: nil)
//        self.movieImage.image = movieImage.image
//    }
//
//    private lazy var closeButton: UIButton = build {
//        $0.setTitle("Close", for: .normal)
//        $0.setTitleColor(.systemBlue, for: .normal)
//        $0.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
//    }
//
//
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        addGesture()
//    }
//
//    // MARK: - Methods
//    private func setupUI() {
//        view.backgroundColor = .systemBackground
//        movieImage.frame = view.bounds
//        view.addSubview(movieImage)
//        view.addSubview(closeButton)
//
//        closeButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(10)
//            make.trailing.equalToSuperview().offset(-20)
//        }
//    }
//
//    private func addGesture() {
//        let pinchGesture = UIPinchGestureRecognizer(
//            target: self,
//            action: #selector(pinch(_:))
//        )
//        movieImage.addGestureRecognizer(pinchGesture)
//        movieImage.isUserInteractionEnabled = true
//    }
//
//    @objc func pinch(_ sender: UIPinchGestureRecognizer) {
//        if sender.state == .began || sender.state == .changed {
//            let currentScale = self.movieImage.frame.size.width / self.movieImage.bounds.size.width
//            let newScale = currentScale * sender.scale
//            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
//            self.movieImage.transform = transform
//            sender.scale = 1
//        } else if sender.state == .ended {
//            // Check if scale is less than the original size (zoom out)
//            let currentScale = self.movieImage.frame.size.width / self.movieImage.bounds.size.width
//            if currentScale < 1.0 {
//                // If zoomed out, reset to the original size
//                self.movieImage.transform = CGAffineTransform.identity
//            }
//        }
//    }
//
//    @objc private func closeTapped() {
//        dismiss(animated: true, completion: nil)
//    }
//}

import UIKit

final class ImageVC: UIViewController {

    private lazy var movieImage: UIImageView = build {
        $0.contentMode = .scaleAspectFit
    }

    init(movieImage: UIImageView) {
        super.init(nibName: nil, bundle: nil)
        self.movieImage.image = movieImage.image
    }

    private lazy var closeButton: UIButton = build {
        $0.setTitle("Close", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGesture()
    }

    // MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        movieImage.frame = view.bounds
        view.addSubview(movieImage)
        view.addSubview(closeButton)

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    private func addGesture() {
        let pinchGesture = UIPinchGestureRecognizer(
            target: self,
            action: #selector(pinch(_:))
        )
        movieImage.addGestureRecognizer(pinchGesture)
        movieImage.isUserInteractionEnabled = true
    }

    @objc func pinch(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let currentScale = self.movieImage.frame.size.width / self.movieImage.bounds.size.width
            let newScale = currentScale * sender.scale
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            self.movieImage.transform = transform
            sender.scale = 1
        } else if sender.state == .ended {
            // Check if scale is less than the original size (zoom out)
            let currentScale = self.movieImage.frame.size.width / self.movieImage.bounds.size.width
            if currentScale < 1.0 {
                // If zoomed out, reset to the original size
                self.movieImage.transform = CGAffineTransform.identity
            }
        }
    }

    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}

