import RealmSwift
import ObjectMapper

class Article: Object, Mappable {
        
    @objc dynamic var source: Source?
    @objc dynamic var author: String?
    @objc dynamic var title: String = ""
    @objc dynamic var details: String?
    @objc dynamic var urlToImage: String?
    @objc dynamic var publishedAt: String = ""
    @objc dynamic var content: String?
    @objc dynamic var url: String?
    
    override init() {
        
    }

    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        source <- map["source"]
        author <- map["author"]
        title <- map["title"]
        details <- map["description"]
        urlToImage <- map["urlToImage"]
        publishedAt <- map["publishedAt"]
        content <- map["content"]
        url <- map["url"]
    }
    
}
