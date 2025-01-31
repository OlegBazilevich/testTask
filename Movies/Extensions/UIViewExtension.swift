
import UIKit

extension UIView {
    func makeShadow() {
        let layer: CALayer = self.layer
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 10
        layer.masksToBounds = false
    }
}

