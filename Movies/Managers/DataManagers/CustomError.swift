
import Foundation

enum CustomError {
    case noConnection, noData
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .noData:
                return Constants.AlertAnswers.noDataByThisParametrs
            case .noConnection:
                return Constants.AlertAnswers.noConnectionShort
        }
    }
}
