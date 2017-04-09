import UIKit
import Firebase
import Foundation

class PostReview: UIViewController {

    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var postTxt: UITextField!
    @IBOutlet weak var titleTxt: UITextField!
    
    typealias PostType = Dictionary<String, Any>
    var post : PostType = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        
        postTxt.text = post["Description"] as! String?
        titleTxt.text = post["Title"] as! String?
        
        DispatchQueue.global().sync {
            
            // Obtenemos imagen desde nombre de la mimsa y su referencia en Storage
            let storageRef = FIRStorage.storage().reference(forURL: "gs://kcpracticaboot4.appspot.com")
            let userImagesRef = storageRef.child("userImages")
            // Referencia de la imagen
            let nameImage = post["PhotoStorageName"] as! String
            let imageRef = userImagesRef.child(nameImage)
            
            // Descargamos imagen
            
            _ = imageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
                if (error != nil) {
                    print("error el bajar la imagen")
                } else {
                    let image = UIImage(data: data! as Data)
                    let imageView = UIImageView(image: image)
                    
                    DispatchQueue.main.async {
                        self.imagePost = imageView
                        // Recargamos imagen para cargar las imágenes al arrancar la vista
                        // sino, como se cargan aquí dentro de la closure se cargarían después
                        self.imagePost.reloadInputViews()
                    }
                }
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rateAction(_ sender: Any) {
        print("\((sender as! UISlider).value)")
    }

    @IBAction func ratePost(_ sender: Any) {
        
        DispatchQueue.global().sync {
            
            // Obtenemos postId del post valorado y usuario actual
            let postId = post["postId"] as! String
            let currentUserId = FIRAuth.auth()?.currentUser?.uid
            
            // Rutas
            let rootRef = FIRDatabase.database().reference()
            let publishRef = rootRef.child("publishedPosts")
            let userRef = rootRef.child("Users").child(currentUserId!)
            
            // Descargamos valoración TotalValoration y NumValorations
            let totalValoration = post["TotalValoration"] as! Float
            let numValorations = post["NumValorations"] as! Float
            
            // Sumamos +1 a NumValoration y la valoracion a la valoracion total
            let actualizedTotalValoration = totalValoration + self.rateSlider.value
            let actualizedNumValoration = numValorations + 1
            
            // Recalculamos su media
            let medValoration : Float = actualizedTotalValoration / actualizedNumValoration
            
            // Subimos los resultados al backend, rama publish
            publishRef.child(postId).updateChildValues(["MedValoration" : medValoration])
            publishRef.child(postId).updateChildValues(["NumValorations" : actualizedNumValoration])
            publishRef.child(postId).updateChildValues(["TotalValoration" : actualizedTotalValoration])

            // Subimos los resultados al backend, rama Users, para mantener ambas actualizadas
            userRef.child(postId).updateChildValues(["MedValoration" : medValoration])
            userRef.child(postId).updateChildValues(["NumValorations" : actualizedNumValoration])
            userRef.child(postId).updateChildValues(["TotalValoration" : actualizedTotalValoration])

            
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
