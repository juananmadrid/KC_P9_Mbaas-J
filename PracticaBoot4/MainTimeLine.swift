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

        DispatchQueue.global().async {
            // Inicio de sesion automático como usuario Anonimo si no hay logado ningun usuario
            if FIRAuth.auth()?.currentUser == nil {
                self.loadAnonimousUser()
            }
            
            let rootRef = FIRDatabase.database().reference()
            let rootPublish = rootRef.child("publishedPosts")
            
            // Observamos los cambios en la DB para detectar cambios en tiempo real
            // .value detecta cualquier cambio en esa rama
            rootPublish.queryOrdered(byChild: "Date").observe(FIRDataEventType.value, with: { (snap) in
                if snap.childrenCount != 0 {
                    
                    // Bajamos post y lo casteamos para obtener dictionary de dictionarys
                    let dict = snap.value as! [String : PostType]
                    
                    // Convertimos dictionary de dictionary en array de dictionary
                    self.model = conversToArray(dict)
                    
                } else {
                    print("No hay ningún post")
                    return
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            })  { (error) in
                print(error)
            }
            
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
        // Si usuario es anonimo o nil muestro alert
        if let _ = FIRAuth.auth()?.currentUser {
            
            if (FIRAuth.auth()?.currentUser?.isAnonymous)! {
                showAuthAlert()
            }
                launchViewAuthorPostList()
        } else {
            showAuthAlert()
        }
    }
    
    
    @IBAction func Logout(_ sender: Any) {
        // Logout provoca que usuario pase a ser Anonimous
        if (FIRAuth.auth()?.currentUser?.isAnonymous)! {
            return
        }
        if let _ = FIRAuth.auth()?.currentUser {
            loadAnonimousUser()
    
        // Dejo aquí código de singOut() para tenerlo de referencia
          //  do {
          //      try FIRAuth.auth()?.signOut()
          //   } catch let error {
          //       print("\(error.localizedDescription)")
          //   }
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

        DispatchQueue.global().async {
            
            // Obtenemos imagen desde nombre de la mimsa y su referencia en Storage
            let storageRef = FIRStorage.storage().reference(forURL: "gs://kcpracticaboot4.appspot.com")
            let userImagesRef = storageRef.child("userImages")
            // Referencia de la imagen
            let nameImage = post["PhotoStorageName"] as! String
            let imageRef = userImagesRef.child(nameImage)
            
            // Descargamos imagen
            let data = imageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
                if (error != nil) {
                    print("error el bajar la imagen")
                } else {
                    let image = UIImage(data: data! as Data)
                    
                    DispatchQueue.main.async {
                        cell.imageView?.image = image
                    }
                }
            }
            
        }
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
                                        
                                        DispatchQueue.global().sync {
                                            FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passField.text!, completion: { (user, error) in
                                                if let _ = error {
                                                    print("Login Error: \(error?.localizedDescription)")
                                                    return
                                                }
                                                self.launchViewAuthorPostList()
                                            })
                                        }
                                        
        }
        
        let registerAction = UIAlertAction(title: "Register",
                                           style: .default,
                                           handler: { (action) in
                                            let emailField = (alert.textFields?[0])!
                                            let passField = (alert.textFields?[1])!
                                            
                                            if (emailField.text?.isEmpty)!, (passField.text?.isEmpty)! {
                                                print("Usuario o password en blanco")
                                            }
                                            
                                            DispatchQueue.global().sync {
                                                FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passField.text!, completion: { (user, error) in
                                                    if let _ = error {
                                                        print("Error creando \(user?.email). \(error?.localizedDescription)")
                                                        return
                                                    }
                                                    print("Usuario nuevo creado con éxito: \(user?.email)")
                                                })
                                            }
                                            
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

    func loadAnonimousUser() {
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
            if let _ = error {
                print("Error creando Usuario Anonimo. \(error?.localizedDescription)")
                return
            }
            print("Usuario Anonimo creado con éxito")
        }

    }
    

}
