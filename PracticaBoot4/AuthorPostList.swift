import UIKit
import Firebase

class AuthorPostList: UITableViewController {

    let cellIdentifier = "POSTAUTOR"
    let numberOfSectionsInTable = 1
    
    typealias PostType = Dictionary<String, Any>
    
    var model : [PostType] = []
    // var model = ["test1", "test2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(hadleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    func hadleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        // Uid de usuario
        let currentUserId = FIRAuth.auth()?.currentUser?.uid
        // Referencias a la DB
        let rootRef = FIRDatabase.database().reference()            // root
        let usersRef = rootRef.child("Users")                       // DB users
        let userCurrentRef = usersRef.child(currentUserId!)         // DB de currentuser
        
        userCurrentRef.observe(FIRDataEventType.value, with: { (snap) in
            
            if snap.childrenCount != 0 {
                
                // Bajamos post y lo casteamos para obtener dictionary de dictionarys
                let dict = snap.value as! [String : PostType]
                
                // Convertimos dictionary de dictionary en array de dictionary
                self.model = self.conversToArray(dict)
                
                
            } else {
                print("Usuario no tiene ningún post")
                return
            }
            
            self.tableView.reloadData()
            
        })  { (error) in
            print(error)
        }
        
    }
    
    func conversToArray(_ dict : Dictionary<String, Any>) -> [PostType] {
        
        var arrayDict : [PostType] = []

        for (key, _) in dict {
            arrayDict.append(dict[key] as! PostType)
        }
        return arrayDict
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSectionsInTable
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model.isEmpty {
            return 0
        }
        return model.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        // cell.textLabel?.text = model[indexPath.row]
        
        let post = model[indexPath.row]
        
        cell.textLabel?.text = post["Title"] as! String?
        cell.detailTextLabel?.text = post["Description"] as! String?
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let publish = UITableViewRowAction(style: .normal, title: "Publicar") { (action, indexPath) in
            // Codigo para publicar el post
        }
        publish.backgroundColor = UIColor.green
        let deleteRow = UITableViewRowAction(style: .destructive, title: "Eliminar") { (action, indexPath) in
            // codigo para eliminar
        }
        return [publish, deleteRow]
    }

   
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
