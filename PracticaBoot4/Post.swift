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
         postId: Int,
         date: Date){
        
        post = [:]
        
        post = ["Author": author,
                 "Title": title,
                 "Description" : description,
                 "PhotoStorageName" : photoStorageName,
                 "PublishState" : publishState,
                 "Valoration" : valoration,
                 "postId": postId,
                 "Date" : Date()
        ]
    }

    
    convenience init(author: String,
                     title: String,
                     description: String,
                     photoStorageName: String,
                     publishState: Bool,
                     postId: Int,
                     date: Date) {
        self.init(author: author,
                  title: title,
                  description: description,
                  photoStorageName: photoStorageName,
                  publishState: publishState,
                  postId: 0,
                  date: date
                  )
    }
    
    
}



