import RealmSwift

final class RealmDB {
    static let database = try! Realm()
    
    static func getNews() -> [Article] {
        let news = Array(database.objects(Article.self))
        return news
    }
    
    static func saveArticle(_ article: Article) {
        try! database.write {
            database.add(article)
        }
    }
}
