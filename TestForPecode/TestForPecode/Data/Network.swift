import Alamofire
import AlamofireObjectMapper

typealias Completion = (Error?) -> ()

final class Network {
    static let url = "https://newsapi.org/v2/top-headlines?category=business&apiKey=39f797dbda78481bad174d2317fa3fb5&sortBy=publishedAt"
    
    static func getNews(page: Int, search: String?, country: String?, _ completion: @escaping Completion) {
        
        let search = search ?? ""
        let country = country ?? "us"
        
        let url = url + "&page=\(page)&q=\(search)&country=\(country)"
                
        AF.request(url).responseObject { (response: DataResponse<News, AFError>) in
            switch response.result {
            case let .success(news):
                if page == 0 {
                    AppData.news = news
                }
                else {
                    AppData.news.articles += news.articles
                }
                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }
}
