import UIKit
import WebKit

class WebViewController: UIViewController {
    var url: URL!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
