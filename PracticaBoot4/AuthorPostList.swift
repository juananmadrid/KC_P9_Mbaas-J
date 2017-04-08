import UIKit
import Firebase

class AuthorPostList: UITableViewController {

    let cellIdentifier = "POSTAUTOR"
    let numberOfSectionsInTable = 1
    
    
    typealias PostType = Dictionary<String, Any>
    
    var model : [PostType] = []
    
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
        
        DispatchQueue.global().sync {
            
            let userCurrentRef = ObtainUserCurrentRef()
            
            userCurrentRef.queryOrdered(byChild: "Date").observe(FIRDataEventType.value, with: { (snap) in
                
                if snap.childrenCount != 0 {
                    
                    // Bajamos post y lo casteamos para obtener dictionary de dictionarys
                    let dict = snap.value as! [String : PostType]
                    
                    // Convertimos dictionary de dictionary en array de dictionary
                    self.model = conversToArray(dict)
                    
                    
                } else {
                    print("Usuario no tiene ningún post")
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
        
        DispatchQueue.global().sync {
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
                        tableView.reloadData()
                    }
                }
            }
            
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let publish = UITableViewRowAction(style: .normal, title: "Publicar") { (action, indexPath) in
            // Codigo para publicar post seleccionado
            
            // Obtenemos ruta de usuario
            let userCurrentRef = ObtainUserCurrentRef()
            
            // Obtenemos referencia al post seleccionado (es la key del array)
            let postDict = self.model[indexPath.row] as Dictionary
            let postId = postDict["postId"] as! String
            
            // Cambiamos estado del post seleccionado
            userCurrentRef.child(postId).updateChildValues(["PublishState" : true])
            
            // Recuperamos post seleccionado
            let postRef = userCurrentRef.child(postId)
            
            DispatchQueue.global().sync {
                // Copiamos post seleccionado en ruta \publishedPosts
                postRef.observeSingleEvent(of: .value, with: { (snap) in
                    // Usamos observeSingleEvent porque si solo lo usamos una vez, si usamos
                    // observe hace crash pq vuelve a observarlo al borrar un publicado
                    
                    let post = snap.value as! [String : Any]
                    
                    // Copiamos post en \publishedPosts
                    let rootRef = FIRDatabase.database().reference()
                    let rootPublish = rootRef.child("publishedPosts")
                    
                    rootPublish.updateChildValues(["/\(postId)" : post])
                    
                }) { (error) in
                    print(error)
                }
            }
            
        }
        
        
        publish.backgroundColor = UIColor.green
        let deleteRow = UITableViewRowAction(style: .destructive, title: "Eliminar") { (action, indexPath) in
            // codigo para eliminar post seleccionado
            
            DispatchQueue.global().sync {
                
                // Obtenemos ruta de usuario y anuncios publicados
                let userCurrentRef = ObtainUserCurrentRef()
                let rootRef = FIRDatabase.database().reference()
                let rootPublish = rootRef.child("publishedPosts")
                
                // Obtenemos referencia al post seleccionado (es la key del array)
                let postDict = self.model[indexPath.row] as Dictionary
                let postId = postDict["postId"] as! String
                
                // Eliminamos post seleccionado
                userCurrentRef.child(postId).setValue(nil)
                rootPublish.child(postId).setValue(nil)
            }
        }
        return [publish, deleteRow]
    }


}

// MARK: - UTILS

public
func ObtainUserCurrentRef () -> FIRDatabaseReference {
    
    // Uid de usuario
    let currentUserId = FIRAuth.auth()?.currentUser?.uid
    // Referencias a la DB
    let rootRef = FIRDatabase.database().reference()
    let usersRef = rootRef.child("Users")
    let userCurrentRef = usersRef.child(currentUserId!)

    return(userCurrentRef)
}

// Convertimos dictionary de dictionary en array de dictionary extrayendo de cada postId el dictionary
// que lleva dentro y aprovechamos para añadir en cada dictionay su postId para usarlo en Publish y Delete
public
func conversToArray(_ dict : Dictionary<String, Any>) -> [Dictionary<String, Any>] {
    
    typealias PostType = Dictionary<String, Any>
    
    var arrayDict : [PostType] = []
    
    for (key, _) in dict {
        arrayDict.append(dict[key] as! PostType)
    }
    return arrayDict
}

