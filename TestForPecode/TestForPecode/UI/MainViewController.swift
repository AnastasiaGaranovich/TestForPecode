import UIKit
import iOSDropDown
import PaginatedTableView

final class MainViewController: UIViewController {
    
    private let control = UIRefreshControl()
    
    @IBOutlet private weak var countryDropDown: DropDown!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: PaginatedTableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "Cell")
        Network.getNews(page: 0, search: searchBar.text, country: countryDropDown.text) { error in
            if let error = error {
                self.showError(error.localizedDescription)
                return
            }
            self.tableView.reloadData()
        }
        
        control.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(control)
        tableView.estimatedRowHeight = 250
        tableView.paginatedDelegate = self
        tableView.paginatedDataSource = self
        
        searchBar.delegate = self
        
        countryDropDown.optionArray = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]
        
        countryDropDown.didSelect { value, _, _ in
            print("spesss")
            print(value)
            self.refresh(value)
        }
    }
    
    @IBAction func didPressCountryButton(_ sender: Any) {
        
    }
    
    @objc func refresh(_ country: String?) {
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

extension MainViewController: PaginatedTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AppData.news.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        cell.setup(for: AppData.news.articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
    
extension MainViewController: PaginatedTableViewDelegate {
    func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?) {
        
        Network.getNews(page: pageNumber + 1, search: searchBar.text, country: countryDropDown.text){ error in
            
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
        
        print("page number: \(pageNumber)")
        print("page size: \(pageSize)")
        print(pageSize)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        controller.url = AppData.news.articles[indexPath.row].url
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 1)
    }

    @objc func reload(_ searchBar: UISearchBar) {
        print("refresh")
        refresh(countryDropDown.text)
    }
}
