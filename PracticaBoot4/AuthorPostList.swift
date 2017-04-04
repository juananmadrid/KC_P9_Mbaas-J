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

    // MARK: - Firebase 
    
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
                self.model = conversToArray(dict)
                
                
            } else {
                print("Usuario no tiene ningún post")
                return
            }
            
            self.tableView.reloadData()
            
        })  { (error) in
            print(error)
        }
        
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
        cell.detailTextLabel?.text = post["Author"] as! String?
        // cell.imageView?.image = UIImage(named: )
        
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


}

// MARK: - UTILS

public
func conversToArray(_ dict : Dictionary<String, Any>) -> [Dictionary<String, Any>] {
    
    typealias PostType = Dictionary<String, Any>
    
    var arrayDict : [PostType] = []
    
    for (key, _) in dict {
        arrayDict.append(dict[key] as! PostType)
    }
    return arrayDict
}

