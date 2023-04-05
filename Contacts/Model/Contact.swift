import UIKit

struct Contact {
    var name: String
    var phone: String
    var image: Data?
    var identifier: String
    
    init(name: String, phone: String, image: Data?, identifier: String) {
        self.name = name
        self.phone = phone
        self.image = image
        self.identifier = identifier
    }
}
