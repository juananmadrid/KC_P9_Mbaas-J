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
    var dict : [String : Any]
    

    init(author: String,
         title: String,
         description: String,
         photoName: String,
         publishState: Bool,
         valoration: Int){
        
        dict = [:]
        
        dict = ["Author": author,
                 "Title": title,
                 "Description" : description,
                 "Photo" : photoName,
                 "State" : publishState,
                 "Valoration" : valoration
        ]
    }

    convenience init(author: String,
                     title: String,
                     description: String,
                     photoName: String,
                     publishState: Bool) {
        self.init(author: author,
                  title: title,
                  description: description,
                  photoName: photoName,
                  publishState: publishState,
                  valoration: 0
            
                  )
    }
    
    
}



