import iOSDropDown
import PaginatedTableView
import UIKit

final class ArticlesViewController: UIViewController {
    // MARK: Properties
    
    private let control = UIRefreshControl()
    
    // MARK: Outlets
    
    @IBOutlet private weak var countryDropDown: DropDown!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: PaginatedTableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupDropDown()
        setupTableView()
        Network.getNews(page: 0, search: searchBar.text, country: countryDropDown.text) { error in
            if let error = error {
                self.showError(error.localizedDescription)
                return
            }
            self.tableView.reloadData()
        }
    }
}

// MARK: - Methods

private extension ArticlesViewController {
    func setupDropDown() {
        countryDropDown.optionArray = StaticData.countries
        countryDropDown.didSelect { value, _, _ in
            self.refresh(value)
        }
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: ArticleCell.identifier, bundle: nil), forCellReuseIdentifier: ArticleCell.identifier)
        control.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(control)
        tableView.estimatedRowHeight = 250
        tableView.paginatedDelegate = self
        tableView.paginatedDataSource = self
    }
}

extension ArticlesViewController {
    @objc func refresh(_ country: Any?) {
        var country = country as? String
        country = country ?? countryDropDown.text
        
        Network.getNews(page: 0, search: searchBar.text, country: country) { error in
            if let error = error {
                self.showError(error.localizedDescription)
                return
            }
            self.control.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

// MARK: - PaginatedTableViewDataSource

extension ArticlesViewController: PaginatedTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AppData.news.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier, for: indexPath) as! ArticleCell
        cell.delegate = self
        cell.setup(for: AppData.news.articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - PaginatedTableViewDelegate

extension ArticlesViewController: PaginatedTableViewDelegate {
    func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?) {
        Network.getNews(page: pageNumber + 1, search: searchBar.text, country: countryDropDown.text) { error in
            if let error = error {
                onError?(error)
                return
            }
            
            if AppData.news.totalResults == AppData.news.articles.count {
                onSuccess?(false)
            }
            else {
                onSuccess?(true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: AppData.news.articles[indexPath.row].url ?? "") else {
            showError("Failed to get article URL")
            return
        }
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        controller.url = url
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension ArticlesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 1)
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        refresh(countryDropDown.text)
    }
}

// MARK: - CellDelegate

extension ArticlesViewController: CellDelegate {
    func cellDidPressSave(_ article: Article) {
        if !article.isSaved {
            AppData.savedNews.append(article)
            RealmDB.saveArticle(article)
        }
    }
}
