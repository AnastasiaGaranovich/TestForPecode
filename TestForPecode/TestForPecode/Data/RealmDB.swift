import Foundation
import RealmSwift

class RealmDB {
    static let database = try! Realm()
    
    static func getNews() -> [Article] {
        let news = Array(database.objects(Article.self))
        return news
    }
    
    static func saveNews(news: Article) {
        try! database.write {
            database.add(news)
        }
    }
}
