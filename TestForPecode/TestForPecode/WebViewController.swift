import UIKit
import WebKit

final class WebViewController: UIViewController {
    var url: URL!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
