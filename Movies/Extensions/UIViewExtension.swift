
import UIKit

extension UIView {
    func makeShadow() -> UIView {
        let layer: CALayer = self.layer
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 15.0
        return self
    }
}
