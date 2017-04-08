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
         medValoration: Float,
         numValorations: Float,
         totalValoration: Float,
         postId: String,
         date: Date){
        
        post = [:]
        
        post = ["Author": author,
                 "Title": title,
                 "Description" : description,
                 "PhotoStorageName" : photoStorageName,
                 "PublishState" : publishState,
                 "MedValoration" : medValoration,
                 "NumValorations": numValorations,
                 "TotalValoration" : totalValoration,
                 "postId": postId,
                 "Date" : Date()
        ]
    }

    
    convenience init(author: String,
                     title: String,
                     description: String,
                     photoStorageName: String,
                     publishState: Bool,
                     postId: String,
                     date: Date) {
        self.init(author: author,
                  title: title,
                  description: description,
                  photoStorageName: photoStorageName,
                  publishState: publishState,
                  medValoration : 0,
                  numValorations : 0,
                  totalValoration : 0,
                  postId: postId,
                  date: date
                  )}

    
}




