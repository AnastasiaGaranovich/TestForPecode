import Alamofire
import Foundation

typealias Completion = (Error?) -> ()

class Network {
    
    static let url = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=39f797dbda78481bad174d2317fa3fb5"

    static func getPage(_ page: Int, _ completion: @escaping Completion) {
        AF.request(url + "&page=\(page)").responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let news = try JSONDecoder().decode(News.self, from: data)
                    
                    if page == 0 {
                        AppData.news = news
                    }
                    else {
                        AppData.news.articles += news.articles
                    }
                    
                    print("total results: \(AppData.news.totalResults)")
                    print("articles: \(AppData.news.articles.count)")


                    completion(nil)
                } catch let error {
                    print(error)
                    completion(error)
                }
            case .failure(let error):
                print("Error: \(error)")
                completion(error)
            }
        }
    }
}
