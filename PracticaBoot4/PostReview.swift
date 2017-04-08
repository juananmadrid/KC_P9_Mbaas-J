import UIKit
import Firebase

class PostReview: UIViewController {

    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var postTxt: UITextField!
    @IBOutlet weak var titleTxt: UITextField!
    
    typealias PostType = Dictionary<String, Any>
    var post : PostType = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            
            // Obtenemos postId del post valorado
            let postId = post["postId"] as! String
            
            // Sumamos nueva valoración al total
            let rootRef = FIRDatabase.database().reference()
            let publishRef = rootRef.child("publishedPosts")
            
            // Descargamos valoración TotalValoration y NumValorations
            
            let totalValoration = post["TotalValoration"] as! Float
            let numValorations = post["NumValorations"] as! Float
            
            // Sumamos +1 a NumValoration y la valoracion a la valoracion total
            let actualizedTotalValoration = totalValoration + self.rateSlider.value
            let actualizedNumValoration = numValorations + 1
            
            // Recalculamos su media
            let medValoration : Float = actualizedTotalValoration / actualizedNumValoration
            
            // Subimos los resultados al backend
            publishRef.child(postId).updateChildValues(["MedValoration" : medValoration])
            publishRef.child(postId).updateChildValues(["NumValorations" : actualizedNumValoration])
            publishRef.child(postId).updateChildValues(["TotalValoration" : actualizedTotalValoration])

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
