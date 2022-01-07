import UIKit

final class MainViewController: UIViewController {
    let control = UIRefreshControl()
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "Cell")
        Network.getNews { error in
            if let error = error {
                self.showError(error)
                return
            }
            self.tableView.reloadData()
        }
        
        control.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(control)
        tableView.estimatedRowHeight = 250
    }
    
    @objc func refresh(_ sender: AnyObject) {
        Network.getNews { error in
            self.control.endRefreshing()
            if let error = error {
                self.showError(error)
                return
            }
            self.tableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDataSource {

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
    
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        controller.url = AppData.news.articles[indexPath.row].url
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}
