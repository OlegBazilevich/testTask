
//import UIKit
//import SnapKit
//
//final class MoviesListVC: BaseViewController {
//    
//    private lazy var moviesTableView: UITableView = build {
//        $0.separatorStyle = .none
//    }
//    
//    private var moviesModel: [PopMoviesResponseModel] = []
//    private var currentSortingParametr = SortParameterBy.popularity
//    private var filterByButton = UIBarButtonItem()
//    private var uiMenuManager = UIMenuManager.shared
//    private let searchController = UISearchController(searchResultsController: SearchMoviesViewController())
//    
//    private var isSearchBarEmpty: Bool {
//        guard let text = searchController.searchBar.text else { return false }
//        return text.isEmpty
//    }
//    
//    private var isFiltering: Bool {
//        searchController.isActive && !isSearchBarEmpty
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupUI()
//        setUpTableView()
//        getAllMovies()
//        setUpSearchController()
//        setupRefresh()
//        setupFilteredByButton()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        networkMonitor.startMonitoring()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        networkMonitor.stopMonitoring()
//    }
//    
//    private func setupUI() {
//        title = Constants.popularMoviesTitle
//        view.backgroundColor = .systemBackground
//        view.addSubview(moviesTableView)
//        
//        moviesTableView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//    }
//    
//    private func getAllMovies(
//        showActivityIndicator: Bool = true,
//        language: String? = APIConstants.currentAppLanguageID,
//        region: String? = APIConstants.currentRegion,
//        year: String? = APIConstants.currentYear,
//        query: String? = nil,
//        page: Int = APIConstants.currentPage
//    ) {
//        if showActivityIndicator {
//            ActivityIndicatorView.shared.presentedIndicator()
//        }
//        
//        RestService.shared.getAllPopMovies(
//            language: language,
//            region: region,
//            year: year,
//            query: query,
//            page: page
//        ) { [weak self] result in
//            guard let self = self else { return }
//            
//            switch result {
//            case .success(let movies):
//                self.moviesModel.append(contentsOf: movies)
//                
//                DispatchQueue.main.async {
//                    ActivityIndicatorView.shared.hiddenIndicator()
//                    self.moviesTableView.reloadData()
//                    switch self.currentSortingParametr {
//                    case .voteAvarage:
//                        self.setSortedModelToTableView(parametr: .voteAvarage)
//                    case .popularity:
//                        self.setSortedModelToTableView(parametr: .popularity)
//                    }
//                }
//            case .failure(let error):
//                ActivityIndicatorView.shared.hiddenIndicator()
//                MyAlertManager.shared.showErrorAlert(
//                    error.localizedDescription,
//                    controller: self,
//                    forTime: 2
//                )
//            }
//        }
//    }
//    
//    private func setupRefresh() {
//        moviesTableView.refreshControl = UIRefreshControl()
//        moviesTableView.refreshControl?.addTarget(
//            self,
//            action: #selector(didPullRefresh),
//            for: .valueChanged
//        )
//    }
//    
//    @objc private func didPullRefresh() {
//        self.moviesTableView.refreshControl?.beginRefreshing()
//        self.moviesModel.removeAll()
//        APIConstants.currentPage = 1
//        
//        self.getAllMovies(
//            showActivityIndicator: false,
//            language: APIConstants.currentAppLanguageID,
//            region: APIConstants.currentRegion,
//            year: APIConstants.currentYear,
//            query: nil,
//            page: APIConstants.currentPage
//        )
//        
//        self.moviesTableView.refreshControl?.endRefreshing()
//    }
//    
//    private func setUpTableView() {
//        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
//        moviesTableView.delegate = self
//        moviesTableView.dataSource = self
//    }
//    
//    @objc private func upButtonPressed() {
//        let topRow = IndexPath(row: 0, section: 0)
//        
//        moviesTableView.scrollToRow(
//            at: topRow,
//            at: .top,
//            animated: true
//        )
//    }
//    
//    private func setUpSearchController() {
//        let searchMoviesVC = SearchMoviesViewController()
//        let searchController = UISearchController(searchResultsController: searchMoviesVC)
//        searchController.searchResultsUpdater = searchMoviesVC
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = Constants.searchMoviesPlaceholder
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
//    }
//    
//    //    private func setupFilteredByButton(sortTitle: String? = nil) {
//    //
//    //        let sortByMenu = UIMenu( title: Constants.MenuText.sortByTitle, options: .displayInline, children: [
//    //            addSortingAction(
//    //                title: Constants.MenuText.popularityTitle,
//    //                sortedParametr: .popularity
//    //            ),
//    //            addSortingAction(
//    //                title: Constants.MenuText.voteAvaraggeTitle,
//    //                sortedParametr: .voteAvarage
//    //            )
//    //        ]
//    //        )
//    //
//    //        uiMenuManager.checkIfValueNotNil(value: sortTitle, menu: sortByMenu)
//    //
//    //        let finalMenu = UIMenu(children: [sortByMenu])
//    //
//    //        self.filterByButton = UIBarButtonItem(
//    //            image: UIImage(systemName: Constants.MenuText.sliderImage),
//    //            menu: finalMenu
//    //        )
//    //
//    //        navigationItem.rightBarButtonItem = filterByButton
//    //    }
//    
//    private func setupFilteredByButton(sortTitle: String? = nil) {
//        let sortByMenu = UIMenu(
//            title: Constants.MenuText.sortByTitle,
//            options: .displayInline,
//            children: [
//                addSortingAction(
//                    title: Constants.MenuText.popularityTitle,
//                    sortedParametr: .popularity,
//                    isChecked: currentSortingParametr == .popularity
//                ),
//                addSortingAction(
//                    title: Constants.MenuText.voteAvaraggeTitle,
//                    sortedParametr: .voteAvarage,
//                    isChecked: currentSortingParametr == .voteAvarage
//                ),
//                addCancelAction()
//            ]
//        )
//        
//        let finalMenu = UIMenu(children: [sortByMenu])
//        
//        self.filterByButton = UIBarButtonItem(
//            image: UIImage(systemName: Constants.MenuText.sliderImage),
//            menu: finalMenu
//        )
//        
//        navigationItem.rightBarButtonItem = filterByButton
//    }
//    
//    private func addSortingAction(title: String, sortedParametr: SortParameterBy, isChecked: Bool) -> UIAction {
//        return UIAction(title: title, state: isChecked ? .on : .off) { [weak self] _ in
//            self?.currentSortingParametr = sortedParametr
//            self?.setupFilteredByButton()
//            self?.setSortedModelToTableView(parametr: sortedParametr)
//        }
//    }
//    
//    private func addCancelAction() -> UIAction {
//        return UIAction(title: "Cancel", attributes: []) { _ in }
//    }
//    
//}
//
//// MARK: dataSource,delegate
//extension MoviesListVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.moviesModel.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        configurePopMovieCellForItem(models: moviesModel, tableView: tableView, indexPath: indexPath)
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard !self.moviesModel.isEmpty else { return }
//
//        tableViewCellApearingAnimation(tableView, willDisplay: cell, forRowAt: indexPath)
//
//        let totalRezults = RestService.shared.totalResults
//
//        if indexPath.row == moviesModel.count - 1 && totalRezults > moviesModel.count {
//            APIConstants.currentPage += 1
//            self.moviesTableView.tableFooterView = LoaderFooterView.shared.createLoaderFooterView(
//                viewController: self,
//                tableView: moviesTableView
//            )
//
//            getAllMovies(
//                showActivityIndicator: false,
//                language: APIConstants.currentAppLanguageID,
//                region: APIConstants.currentRegion,
//                year: APIConstants.currentYear,
//                query: nil,
//                page: APIConstants.currentPage
//            )
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        Constants.movieTableViewHeight
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        presentMovieDetailVC(models: moviesModel, indexPath: indexPath)
//    }
//}
//
//
//
//
//extension MoviesListVC {
//    enum SortParameterBy {
//        case voteAvarage, popularity
//    }
//    
//    func setSortedModelToTableView(parametr: SortParameterBy) {
//        if parametr == .popularity {
//            let sortedModel = self.moviesModel.sortArray(by: \.popularity!)
//            self.moviesModel.removeAll()
//            self.moviesModel.append(contentsOf: sortedModel)
//            self.currentSortingParametr = .popularity
//            self.moviesTableView.reloadData()
//        } else if parametr == .voteAvarage {
//            let sortedModel = self.moviesModel.sortArray(by: \.voteAverage!)
//            self.moviesModel.removeAll()
//            self.moviesModel.append(contentsOf: sortedModel)
//            self.currentSortingParametr = .voteAvarage
//            self.moviesTableView.reloadData()
//        }
//    }
//    
//    
//    func addSortingAction(title: String, sortedParametr: SortParameterBy) -> UIAction {
//        let action = UIAction( title: title ) { [unowned self] action in
//            
//            self.setSortedModelToTableView(parametr: sortedParametr)
//            setupFilteredByButton(sortTitle: action.title)
//            uiMenuManager.sortTitle = action.title
//        }
//        
//        return action
//    }
//}

//import UIKit
//import SnapKit
//
//final class MoviesListVC: BaseViewController {
//
//    private lazy var moviesTableView: UITableView = build {
//        $0.separatorStyle = .none
//    }
//
//    private var moviesModel: [PopMoviesResponseModel] = []
//    private var currentSortingParametr = SortParameterBy.popularity
//    private var filterByButton = UIBarButtonItem()
//    private var uiMenuManager = UIMenuManager.shared
//    private let searchController = UISearchController(searchResultsController: SearchMoviesViewController())
//
//    private var isSearchBarEmpty: Bool {
//        guard let text = searchController.searchBar.text else { return false }
//        return text.isEmpty
//    }
//
//    private var isFiltering: Bool {
//        searchController.isActive && !isSearchBarEmpty
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupUI()
//        setUpTableView()
//        getAllMovies()
//        setupSearchController()
//        setupRefresh()
//        setupFilteredByButton()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        networkMonitor.startMonitoring()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        networkMonitor.stopMonitoring()
//    }
//
//    private func setupUI() {
//        title = Constants.popularMoviesTitle
//        view.backgroundColor = .systemBackground
//        view.addSubview(moviesTableView)
//
//        moviesTableView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//    }
//   
//    private func getAllMovies(
//        showActivityIndicator: Bool = true,
//        language: String? = APIConstants.currentAppLanguageID,
//        region: String? = APIConstants.currentRegion,
//        year: String? = APIConstants.currentYear,
//        query: String? = nil,
//        page: Int = APIConstants.currentPage
//    ) {
//        if showActivityIndicator {
//            ActivityIndicatorView.shared.presentedIndicator()
//        }
//
//        RestService.shared.getAllPopMovies(
//            language: language,
//            region: region,
//            year: year,
//            query: query,
//            page: page
//        ) { [weak self] result in
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let movies):
//                self.moviesModel.append(contentsOf: movies)
//
//                DispatchQueue.main.async {
//                    ActivityIndicatorView.shared.hiddenIndicator()
//                    self.moviesTableView.reloadData()
//                    switch self.currentSortingParametr {
//                    case .voteAvarage:
//                        self.setSortedModelToTableView(parametr: .voteAvarage)
//                    case .popularity:
//                        self.setSortedModelToTableView(parametr: .popularity)
//                    }
//                }
//            case .failure(let error):
//                ActivityIndicatorView.shared.hiddenIndicator()
//                MyAlertManager.shared.showErrorAlert(
//                    error.localizedDescription,
//                    controller: self,
//                    forTime: 2
//                )
//            }
//        }
//    }
//
//    private func setupRefresh() {
//        moviesTableView.refreshControl = UIRefreshControl()
//        moviesTableView.refreshControl?.addTarget(
//            self,
//            action: #selector(didPullRefresh),
//            for: .valueChanged
//        )
//    }
//
//    @objc private func didPullRefresh() {
//        self.moviesTableView.refreshControl?.beginRefreshing()
//        self.moviesModel.removeAll()
//        APIConstants.currentPage = 1
//
//        self.getAllMovies(
//            showActivityIndicator: false,
//            language: APIConstants.currentAppLanguageID,
//            region: APIConstants.currentRegion,
//            year: APIConstants.currentYear,
//            query: nil,
//            page: APIConstants.currentPage
//        )
//
//        self.moviesTableView.refreshControl?.endRefreshing()
//    }
//
//    private func setUpTableView() {
//        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
//        moviesTableView.delegate = self
//        moviesTableView.dataSource = self
//    }
//
//    @objc private func upButtonPressed() {
//        let topRow = IndexPath(row: 0, section: 0)
//
//        moviesTableView.scrollToRow(
//            at: topRow,
//            at: .top,
//            animated: true
//        )
//    }
//
//    private func setupSearchController() {
//        let searchMoviesVC = SearchMoviesViewController()
//        let searchController = UISearchController(searchResultsController: searchMoviesVC)
//        searchController.searchResultsUpdater = searchMoviesVC
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = Constants.searchMoviesPlaceholder
//        searchController.hidesNavigationBarDuringPresentation = false
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
//    }
//   
//    private func setupFilteredByButton(sortTitle: String? = nil) {
//        let sortByMenu = UIMenu(
//            title: Constants.MenuText.sortByTitle,
//            options: .displayInline,
//            children: [
//                addSortingAction(
//                    title: Constants.MenuText.popularityTitle,
//                    sortedParametr: .popularity,
//                    isChecked: currentSortingParametr == .popularity
//                ),
//                addSortingAction(
//                    title: Constants.MenuText.voteAvaraggeTitle,
//                    sortedParametr: .voteAvarage,
//                    isChecked: currentSortingParametr == .voteAvarage
//                ),
//                addCancelAction()
//            ]
//        )
//
//        let finalMenu = UIMenu(children: [sortByMenu])
//
//        self.filterByButton = UIBarButtonItem(
//            image: UIImage(systemName: Constants.MenuText.sliderImage),
//            menu: finalMenu
//        )
//
//        navigationItem.rightBarButtonItem = filterByButton
//    }
//
//    private func addSortingAction(title: String, sortedParametr: SortParameterBy, isChecked: Bool) -> UIAction {
//        return UIAction(title: title, state: isChecked ? .on : .off) { [weak self] _ in
//            self?.currentSortingParametr = sortedParametr
//            self?.setupFilteredByButton()
//            self?.setSortedModelToTableView(parametr: sortedParametr)
//        }
//    }
//
//    private func addCancelAction() -> UIAction {
//        return UIAction(title: "Cancel", attributes: []) { _ in }
//    }
//
//}
//
//// MARK: dataSource,delegate
//extension MoviesListVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.moviesModel.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        configurePopMovieCellForItem(models: moviesModel, tableView: tableView, indexPath: indexPath)
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard !self.moviesModel.isEmpty else { return }
//
//        tableViewCellApearingAnimation(tableView, willDisplay: cell, forRowAt: indexPath)
//
//        let totalRezults = RestService.shared.totalResults
//
//        if indexPath.row == moviesModel.count - 1 && totalRezults > moviesModel.count {
//            APIConstants.currentPage += 1
//            self.moviesTableView.tableFooterView = LoaderFooterView.shared.createLoaderFooterView(
//                viewController: self,
//                tableView: moviesTableView
//            )
//
//            getAllMovies(
//                showActivityIndicator: false,
//                language: APIConstants.currentAppLanguageID,
//                region: APIConstants.currentRegion,
//                year: APIConstants.currentYear,
//                query: nil,
//                page: APIConstants.currentPage
//            )
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        Constants.movieTableViewHeight
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        presentMovieDetailVC(models: moviesModel, indexPath: indexPath)
//    }
//}
//
//
//
//
//extension MoviesListVC {
//    enum SortParameterBy {
//        case voteAvarage, popularity
//    }
//
//    func setSortedModelToTableView(parametr: SortParameterBy) {
//        if parametr == .popularity {
//            let sortedModel = self.moviesModel.sortArray(by: \.popularity!)
//            self.moviesModel.removeAll()
//            self.moviesModel.append(contentsOf: sortedModel)
//            self.currentSortingParametr = .popularity
//            self.moviesTableView.reloadData()
//        } else if parametr == .voteAvarage {
//            let sortedModel = self.moviesModel.sortArray(by: \.voteAverage!)
//            self.moviesModel.removeAll()
//            self.moviesModel.append(contentsOf: sortedModel)
//            self.currentSortingParametr = .voteAvarage
//            self.moviesTableView.reloadData()
//        }
//    }
//
//
//    func addSortingAction(title: String, sortedParametr: SortParameterBy) -> UIAction {
//        let action = UIAction( title: title ) { [unowned self] action in
//
//            self.setSortedModelToTableView(parametr: sortedParametr)
//            setupFilteredByButton(sortTitle: action.title)
//            uiMenuManager.sortTitle = action.title
//        }
//
//        return action
//    }
//}


import UIKit
import SnapKit

final class MoviesListVC: BaseViewController {

    private lazy var moviesTableView: UITableView = build {
        $0.separatorStyle = .none
    }

    private var moviesModel: [PopMoviesResponseModel] = []
    private var currentSortingParametr = SortParameterBy.popularity
    private var filterByButton = UIBarButtonItem()
    private var uiMenuManager = UIMenuManager.shared
    private let searchController = UISearchController(searchResultsController: SearchMoviesViewController())

    private var isSearchBarEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }

    private var isFiltering: Bool {
        searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setUpTableView()
        getAllMovies()
        setupSearchController()
        setupRefresh()
        setupFilteredByButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        networkMonitor.startMonitoring()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        networkMonitor.stopMonitoring()
    }

    private func setupUI() {
        title = Constants.popularMoviesTitle
        view.backgroundColor = .systemBackground
        view.addSubview(moviesTableView)

        moviesTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func getAllMovies(
        showActivityIndicator: Bool = true,
        language: String? = APIConstants.currentAppLanguageID,
        region: String? = APIConstants.currentRegion,
        year: String? = APIConstants.currentYear,
        query: String? = nil,
        page: Int = APIConstants.currentPage
    ) {
        if showActivityIndicator {
            ActivityIndicatorView.shared.presentedIndicator()
        }

        RestService.shared.getAllPopMovies(
            language: language,
            region: region,
            year: year,
            query: query,
            page: page
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let movies):
                self.moviesModel.append(contentsOf: movies)

                DispatchQueue.main.async {
                    ActivityIndicatorView.shared.hiddenIndicator()
                    self.moviesTableView.reloadData()
                    switch self.currentSortingParametr {
                    case .voteAvarage:
                        self.setSortedModelToTableView(parametr: .voteAvarage)
                    case .popularity:
                        self.setSortedModelToTableView(parametr: .popularity)
                    }
                }
            case .failure(let error):
                ActivityIndicatorView.shared.hiddenIndicator()
                MyAlertManager.shared.showErrorAlert(
                    error.localizedDescription,
                    controller: self,
                    forTime: 2
                )
            }
        }
    }

    private func setupRefresh() {
        moviesTableView.refreshControl = UIRefreshControl()
        moviesTableView.refreshControl?.addTarget(
            self,
            action: #selector(didPullRefresh),
            for: .valueChanged
        )
    }

    @objc private func didPullRefresh() {
        self.moviesTableView.refreshControl?.beginRefreshing()
        self.moviesModel.removeAll()
        APIConstants.currentPage = 1

        self.getAllMovies(
            showActivityIndicator: false,
            language: APIConstants.currentAppLanguageID,
            region: APIConstants.currentRegion,
            year: APIConstants.currentYear,
            query: nil,
            page: APIConstants.currentPage
        )

        self.moviesTableView.refreshControl?.endRefreshing()
    }

    private func setUpTableView() {
        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
    }

    @objc private func upButtonPressed() {
        let topRow = IndexPath(row: 0, section: 0)

        moviesTableView.scrollToRow(
            at: topRow,
            at: .top,
            animated: true
        )
    }

    private func setupSearchController() {
        let searchMoviesVC = SearchMoviesViewController()
        let searchController = UISearchController(searchResultsController: searchMoviesVC)
        searchController.searchResultsUpdater = searchMoviesVC
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchMoviesPlaceholder
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupFilteredByButton(sortTitle: String? = nil) {
        let sortByMenu = UIMenu(
            title: Constants.MenuText.sortByTitle,
            options: .displayInline,
            children: [
                addSortingAction(
                    title: Constants.MenuText.popularityTitle,
                    sortedParametr: .popularity,
                    isChecked: currentSortingParametr == .popularity
                ),
                addSortingAction(
                    title: Constants.MenuText.voteAvaraggeTitle,
                    sortedParametr: .voteAvarage,
                    isChecked: currentSortingParametr == .voteAvarage
                ),
                addCancelAction()
            ]
        )

        let finalMenu = UIMenu(children: [sortByMenu])

        self.filterByButton = UIBarButtonItem(
            image: UIImage(systemName: Constants.MenuText.sliderImage),
            menu: finalMenu
        )

        navigationItem.rightBarButtonItem = filterByButton
    }

    private func addSortingAction(title: String, sortedParametr: SortParameterBy, isChecked: Bool) -> UIAction {
        return UIAction(title: title, state: isChecked ? .on : .off) { [weak self] _ in
            self?.currentSortingParametr = sortedParametr
            self?.setupFilteredByButton()
            self?.setSortedModelToTableView(parametr: sortedParametr)
        }
    }

    private func addCancelAction() -> UIAction {
        return UIAction(title: Constants.MenuText.cancel, attributes: []) { _ in }
    }

}

// MARK: dataSource,delegate
extension MoviesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.moviesModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        configurePopMovieCellForItem(models: moviesModel, tableView: tableView, indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !self.moviesModel.isEmpty else { return }

        tableViewCellApearingAnimation(tableView, willDisplay: cell, forRowAt: indexPath)

        let totalRezults = RestService.shared.totalResults

        if indexPath.row == moviesModel.count - 1 && totalRezults > moviesModel.count {
            APIConstants.currentPage += 1
            self.moviesTableView.tableFooterView = LoaderFooterView.shared.createLoaderFooterView(
                viewController: self,
                tableView: moviesTableView
            )

            getAllMovies(
                showActivityIndicator: false,
                language: APIConstants.currentAppLanguageID,
                region: APIConstants.currentRegion,
                year: APIConstants.currentYear,
                query: nil,
                page: APIConstants.currentPage
            )
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.movieTableViewHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentMovieDetailVC(models: moviesModel, indexPath: indexPath)
    }
}




extension MoviesListVC {
    enum SortParameterBy {
        case voteAvarage, popularity
    }

    func setSortedModelToTableView(parametr: SortParameterBy) {
        if parametr == .popularity {
            let sortedModel = self.moviesModel.sortArray(by: \.popularity!)
            self.moviesModel.removeAll()
            self.moviesModel.append(contentsOf: sortedModel)
            self.currentSortingParametr = .popularity
            self.moviesTableView.reloadData()
        } else if parametr == .voteAvarage {
            let sortedModel = self.moviesModel.sortArray(by: \.voteAverage!)
            self.moviesModel.removeAll()
            self.moviesModel.append(contentsOf: sortedModel)
            self.currentSortingParametr = .voteAvarage
            self.moviesTableView.reloadData()
        }
    }


    func addSortingAction(title: String, sortedParametr: SortParameterBy) -> UIAction {
        let action = UIAction( title: title ) { [unowned self] action in

            self.setSortedModelToTableView(parametr: sortedParametr)
            setupFilteredByButton(sortTitle: action.title)
            uiMenuManager.sortTitle = action.title
        }

        return action
    }
}
