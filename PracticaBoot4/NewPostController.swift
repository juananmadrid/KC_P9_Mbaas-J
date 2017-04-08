import UIKit
import Firebase

class NewPostController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titlePostTxt: UITextField!
    @IBOutlet weak var textPostTxt: UITextField!
    @IBOutlet weak var imagePost: UIImageView!
    
    var isReadyToPublish: Bool = false
    var imageCaptured: UIImage! {
        didSet {
            imagePost.image = imageCaptured
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        self.present(pushAlertCameraLibrary(), animated: true, completion: nil)
    }
    
    @IBAction func publishAction(_ sender: Any) {
        isReadyToPublish = (sender as! UISwitch).isOn
        
        if isReadyToPublish == true {
            let currentUserId = FIRAuth.auth()?.currentUser?.uid
            
        } else {
            return
        }
    }

    // persitimos en el cloud
    @IBAction func savePostInCloud(_ sender: Any) {
        
        // Validamos datos antes de subirlos
        guard let author = FIRAuth.auth()?.currentUser?.email,
            let title = titlePostTxt.text else {
                print("Error al introducir Autor o Título")
                return
        }
        
        let description = textPostTxt.text ?? ""
        

        
        // Subimos imagen después de reducir su tamaño. Si no hay imagen subimos imagen vacía
        let defaultImage = UIImage(named: "emptyImage.jpg")
        var image = UIImageJPEGRepresentation(defaultImage!, 0.5)
        
        if imageCaptured != nil {
            image = UIImageJPEGRepresentation(self.imageCaptured, 0.5)
        }
        
        // Referencia al Storage de Firebase
        let storageRef = FIRStorage.storage().reference(forURL: "gs://kcpracticaboot4.appspot.com")
        let userImagesRef = storageRef.child("userImages")
        // Generamos nombre aleatorio
        let nameImage = UUID().uuidString as String
        let nameJPG = "\(nameImage).jpg"
        // Referencia de imagen a subir
        let imageRef = userImagesRef.child(nameJPG)

        
        // Subimos imagen
        imageRef.put(image!, metadata: nil, completion: { (metadata, error) in
            if (error != nil) {
                print("Error al subir la imagen")
            } else {
                print("Imagen subida correctamente")
                // downloadURL = metadata!.downloadURL()
            }
        })
        
        
        var post : Dictionary<String, Any>
        
        post = ["Author": author,
                "Title" : title,
                "Description": description,
                "PhotoStorageName": nameJPG,
                "PublishState": isReadyToPublish,
                "Valoration" : 0,
                "postId": ""
        ]
        // Como ref. de la imagen en post podemos usar el nombre, url u gs.
      
        // Uid de usuario
        let currentUserId = FIRAuth.auth()?.currentUser?.uid

        // Referencias a la DB
        let rootRef = FIRDatabase.database().reference()            // root
        let rootPublish = rootRef.child("publishedPosts")           // root de posts publicados
        let usersRef = rootRef.child("Users")                       // DB users
        let userCurrentRef = usersRef.child(currentUserId!)         // DB de currentuser
        
        // Generamos ID único para el nuevo posts con childByAutoId
        let key = userCurrentRef.childByAutoId().key
        
        // Añadimos a post el postId:
        post.updateValue(key, forKey: "postId")
        
        // Subimos el post colgándolo de esa key (Id único)
        userCurrentRef.updateChildValues(["/\(key)" : post])
        
        // Si está para publicar la publicamos
        if isReadyToPublish {
            rootPublish.updateChildValues(["/\(key)" : post])
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

    // MARK: - Funciones para la CÁMARA
    internal func pushAlertCameraLibrary() -> UIAlertController {
        // AlertController
        let actionSheet = UIAlertController(title: NSLocalizedString("Selecciona la fuente de la imagen", comment: ""), message: NSLocalizedString("", comment: ""), preferredStyle: .actionSheet)
        
        // Actions
        let libraryBtn = UIAlertAction(title: NSLocalizedString("Usar la libreria", comment: ""), style: .default) { (action) in
            self.takePictureFromCameraOrLibrary(.photoLibrary)
            
        }
        let cameraBtn = UIAlertAction(title: NSLocalizedString("Usar la camara", comment: ""), style: .default) { (action) in
            self.takePictureFromCameraOrLibrary(.camera)
            
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        actionSheet.addAction(libraryBtn)
        actionSheet.addAction(cameraBtn)
        actionSheet.addAction(cancel)
        
        return actionSheet
    }
    
    internal func takePictureFromCameraOrLibrary(_ source: UIImagePickerControllerSourceType) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        switch source {
        case .camera:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                picker.sourceType = UIImagePickerControllerSourceType.camera
            } else {
                return
            }
        case .photoLibrary:
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        case .savedPhotosAlbum:
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        self.present(picker, animated: true, completion: nil)
    }

}

// MARK: - Delegado del imagepicker
extension NewPostController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageCaptured = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        self.dismiss(animated: false, completion: {
            
            
        })
    }
    
}












