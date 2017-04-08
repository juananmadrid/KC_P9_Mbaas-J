import Foundation
import UIKit

class Post {
    
    private
    var post : [String : Any]
    
    
    init(author: String,
         title: String,
         description: String,
         photoStorageName: String,
         publishState: Bool,
         valoration: Int,
         postId: Int){
        
        post = [:]
        
        post = ["Author": author,
                 "Title": title,
                 "Description" : description,
                 "PhotoStorageName" : photoStorageName,
                 "PublishState" : publishState,
                 "Valoration" : valoration,
                 "postId": postId
        ]
    }

    
    convenience init(author: String,
                     title: String,
                     description: String,
                     photoStorageName: String,
                     publishState: Bool,
                     postId: Int) {
        self.init(author: author,
                  title: title,
                  description: description,
                  photoStorageName: photoStorageName,
                  publishState: publishState,
                  postId: 0
                  )
    }
    
    
}



