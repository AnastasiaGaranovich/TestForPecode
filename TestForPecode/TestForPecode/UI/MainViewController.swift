import UIKit
import PaginatedTableView

final class MainViewController: UIViewController {
    
    private let control = UIRefreshControl()
    
    @IBOutlet private weak var search: UISearchBar!
    @IBOutlet private weak var tableView: PaginatedTableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "Cell")
        Network.getPage(0) { error in
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
    }
    
    @objc func refresh(_ sender: AnyObject) {
        Network.getPage(0) { error in
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
        
        Network.getPage(pageNumber + 1) { error in
            
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
