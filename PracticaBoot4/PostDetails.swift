import UIKit
import Firebase

class PostDetails: UIViewController {

    
    @IBOutlet weak var posTitle: UILabel!
    @IBOutlet weak var numVal: UILabel!
    @IBOutlet weak var medVal: UILabel!
    
    
    typealias PostType = Dictionary<String, Any>
    var post : PostType = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let numValorations = post["NumValorations"] as! Double
        let totalValoration = post["MedValoration"] as! Double
        
        numVal.text = numValorations.description
        medVal.text = totalValoration.description
        
        
        posTitle.text = post["Title"] as! String?
        
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
