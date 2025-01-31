
import UIKit
import SnapKit

final class ActivityIndicatorView: UIView {
    static var shared = ActivityIndicatorView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupView()
        setupConstraints()
    }

    private func setupView() {
        self.backgroundColor = .systemBackground
        self.frame = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
    }

    private func setupConstraints() {
        self.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func presentedIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if #available(iOS 15.0, *) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                        window.addSubview(self)
                    }
                }
            } else {
                if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    window.addSubview(self)
                }
            }
            
            self.activityIndicator.startAnimating()
        }
    }

    func hiddenIndicator() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.stopAnimating()
        }
    }

    private func stopAnimating() {
        activityIndicator.stopAnimating()
        self.removeFromSuperview()
    }
}
