import Alamofire
import Foundation

class Network {
    static let url = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=39f797dbda78481bad174d2317fa3fb5"
    
    static func getNews(_ completion: @escaping(String?) -> ()) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    AppData.news = try JSONDecoder().decode(News.self, from: data)
                    completion(nil)
                } catch let error {
                    print(error)
                    completion(error.localizedDescription)
                }
                print(data)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(error.localizedDescription)
            }
        }
        
    }
}
