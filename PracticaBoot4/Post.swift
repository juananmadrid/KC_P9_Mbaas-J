import Foundation
import UIKit

class Post {
    
//    let author      :   String
//    let title       :   String
//    let description :   String
//    let photoName   :   String
//    let publishState :  Bool
//    let valoration  :   Int
    
    private
    var _dict : [String : Any]
    

    init(author: String,
         title: String,
         description: String,
         photoName: String,
         publishState: Bool,
         valoration: Int){
        
        _dict = Dictionary()
        
        _dict["Author"] = author
        _dict["Title"] = title
        _dict["Description"] = description
        _dict["PhotoName"] = photoName
        _dict["PublishState"] = publishState
        _dict["Valoration"] = valoration

    }
    
    
    
    
    
    
}



