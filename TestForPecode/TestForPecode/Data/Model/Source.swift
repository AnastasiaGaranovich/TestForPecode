import RealmSwift
import ObjectMapper

class Source: Object, Mappable {
        
    @objc dynamic var id: String? = nil
    @objc dynamic var name: String = ""
    
    override init() {
        
    }
    
    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
}
