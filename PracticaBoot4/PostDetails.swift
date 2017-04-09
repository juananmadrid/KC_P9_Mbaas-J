import UIKit
import Firebase

class PostDetails: UIViewController {

    @IBOutlet weak var titlePost: UILabel!
    @IBOutlet weak var numVal: UILabel!
    @IBOutlet weak var medVal: UILabel!
    
    typealias PostType = Dictionary<String, Any>
    var post : PostType = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        titlePost.text = post["Title"] as! String?
//        numVal.text = post["NumValorations"] as! String?
//        medVal.text = post["MedValoration"] as! String?
        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
