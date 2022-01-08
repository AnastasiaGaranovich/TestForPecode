import ObjectMapper

class News: Mappable {
    
    var status: String = ""
    var totalResults: Int = 0
    var articles: [Article] = []
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        totalResults <- map["totalResults"]
        articles <- map["articles"]
    }
}
