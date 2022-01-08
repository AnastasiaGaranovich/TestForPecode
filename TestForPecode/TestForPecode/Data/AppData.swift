import Foundation

final class AppData {
    static var news = News()
    static var savedNews = RealmDB.getNews()
}
