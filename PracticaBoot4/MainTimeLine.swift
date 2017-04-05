import UIKit
import Firebase
import Foundation

class MainTimeLine: UITableViewController {

    let numberOfSectionsInTable = 1
    typealias PostType = Dictionary<String, Any>
    
    var model : [PostType] = []
    // var model = ["post1", "post2"]
    let cellIdentier = "POSTSCELL"
    
    // Creamos rama en DB para las news
    let postsRef = FIRDatabase.database().reference().child("News")
    

    // MARK: - FIREBASE

    override func viewWillAppear(_ animated: Bool) {

        // Observamos los cambios en la DB para detectar cambios en tiempo real
        // .value detecta cualquier cambio en esa rama
        
        // Referencias a la DB
        let rootRef = FIRDatabase.database().reference()
        let rootPublish = rootRef.child("publishedPosts")
        
        rootPublish.observe(FIRDataEventType.value, with: { (snap) in
            
            if snap.childrenCount != 0 {
                
                // Bajamos post y lo casteamos para obtener dictionary de dictionarys
                let dict = snap.value as! [String : PostType]
                
                // Convertimos dictionary de dictionary en array de dictionary
                self.model = conversToArray(dict)
                
            } else {
                print("No hay ningún post")
                return
            }
            
            self.tableView.reloadData()
            
        })  { (error) in
            print(error)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.refreshControl?.addTarget(self, action: #selector(hadleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    func hadleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - Athentication
    
    @IBAction func LoginAuth(_ sender: Any) {
        if let _ = FIRAuth.auth()?.currentUser {
            launchViewAuthorPostList()
        } else {
            showAuthAlert()
        }
        
    }
    
    
    @IBAction func Logout(_ sender: Any) {
        if let _ = FIRAuth.auth()?.currentUser {
            do {
                try FIRAuth.auth()?.signOut()
            } catch let error {
                print("\(error.localizedDescription)")
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentier, for: indexPath)
        
        let post = model[indexPath.row]
        
        cell.textLabel?.text = post["Title"] as! String?
        cell.detailTextLabel?.text = post["Author"] as! String?

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ShowRatingPost", sender: indexPath)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowRatingPost" {
            let vc = segue.destination as! PostReview
            // aqui pasamos el item selecionado
        }
    }

    // MARK: - Utils
    
    func showAuthAlert() {
        
        // Creamos UIAlert
        let alert = UIAlertController(title: "Login",
                                      message: "Insert Dates",
                                      preferredStyle: .alert)
        
        let signAction = UIAlertAction(title: "Login",
                                       style: .default) { (action) in
                                        let emailField = (alert.textFields?[0])!
                                        let passField = (alert.textFields?[1])!
                                        
                                        if (emailField.text?.isEmpty)!, (passField.text?.isEmpty)! {
                                            print("Usuario o password en blanco")
                                        }
                                        
                                        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passField.text!, completion: { (user, error) in
                                            if let _ = error {
                                                print("Login Error: \(error?.localizedDescription)")
                                                return
                                            }
                                            self.launchViewAuthorPostList()
                                        })
        }
        
        let registerAction = UIAlertAction(title: "Register",
                                           style: .default,
                                           handler: { (action) in
                                            let emailField = (alert.textFields?[0])!
                                            let passField = (alert.textFields?[1])!
                                            
                                            if (emailField.text?.isEmpty)!, (passField.text?.isEmpty)! {
                                                print("Usuario o password en blanco")
                                            }
                                            
                                            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passField.text!, completion: { (user, error) in
                                                if let _ = error {
                                                    print("Error creando \(user?.email). \(error?.localizedDescription)")
                                                    
                                                    return
                                                }
                                                print("Usuario nuevo creado con éxito: \(user?.email)")
                                            })
        })
        
        
        // Añadimos accion Cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("Login cancelado")
        }
        
        // Añadimos texFields
        alert.addTextField { (mailText) in
            mailText.placeholder = "e-mail"
        }
        alert.addTextField { (passText) in
            passText.placeholder = "password"
        }
        
        // Añadimos acción Save y Cancel
        alert.addAction(signAction)
        alert.addAction(registerAction)
        alert.addAction(cancelAction)
        
        // Mostramos UIAlert creado y configurado
        present(alert, animated: true, completion: nil)
        
    }

    func launchViewAuthorPostList() {
        
        let storyboard = UIStoryboard(name: "TimeLine", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AuthorPostList")
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    

}
