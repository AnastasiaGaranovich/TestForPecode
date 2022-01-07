import Foundation

class Article: Codable {
    var source: Source
    var author: String?
    var title: String
    var description: String?
    var urlToImage: URL?
    var publishedAt: String
    var content: String?
    var url: URL
}
