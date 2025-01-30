
import Foundation

extension Sequence {
    var minimalDescription: String {
        map { "\($0)" }.joined(separator: ", ")
    }
}
