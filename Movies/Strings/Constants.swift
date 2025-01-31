
import UIKit

struct Constants {
    enum Fonts {
        static let semibold = UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let light = UIFont.systemFont(ofSize: 16, weight: .light)
    }
    
    enum MenuText {
        static let filterByTitle = "filterByTitle".localized()
        static let sortByTitle = "sortByTitle".localized()
        static let voteAvaraggeTitle = "voteAvaraggeTitle".localized()
        static let popularityTitle = "popularityTitle".localized()
        static let cancel = "cancel".localized()
        static let sliderImage = "line.3.horizontal.decrease"
    }
    
    enum AlertAnswers {
        static var somethingWentWrongAnswear = "somethingWentWrong".localized()
        static var noDataByThisParametrs = "noDataByThisParametrs".localized()
        static var noConnection = "noConnection".localized()
        static var noConnectionShort = "noConnectionShort".localized()
    }

    static let noData = "noData".localized()
    static let popularMoviesTitle = "popularMovies".localized()
    static let searchMoviesPlaceholder = "searchForMovies".localized()
    static let noImageURL = "https://us.123rf.com/450wm/koblizeek/koblizeek1902/koblizeek190200055/koblizeek190200055.jpg?ver=6"
    static let upButtonImage = "chevron.up"
    static let movieTableViewHeight = CGFloat(350)
    static let loaderTableViewHeight = CGFloat(60)
}
