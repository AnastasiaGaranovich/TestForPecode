import UIKit
import WebKit

final class WebViewController: UIViewController {
    // MARK: Properties
    
    var url: URL!
    
    // MARK: Outlets
    
    @IBOutlet private weak var webView: WKWebView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
