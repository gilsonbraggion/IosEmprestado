import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ContaViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    @IBOutlet weak var btnFacebook: FBSDKLoginButton!
    @IBOutlet weak var imagemUsuario: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        labelNome.text = defaults.string(forKey: "userName")
        labelEmail.text = defaults.string(forKey: "userMail")
        carregarFotoUsuario(defaults.string(forKey: "idUser")!)
        
        btnFacebook.delegate = self
    }
    
    // Facebook Delegate Methods
    func loginButton(_ loginButton: FBSDKLoginButton!,
        didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!) {
            
            if ((error) != nil) {
            } else if result.isCancelled {
            } else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if result.grantedPermissions.contains("email") {
                    // Do work
                }
            }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        efetuarLogout()
    }
    
    func efetuarLogout() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! LoginViewController
        self.present(next, animated: true, completion: nil)
        
    }
    
    func carregarFotoUsuario(_ idUsuario : String) {
        
        let urlId =  "https://graph.facebook.com/\(idUsuario)/picture?width=300&height=300"
        let url:URL? = URL(string: urlId)
        let data:Data? = try? Data(contentsOf: url!)
        let image = UIImage(data : data!)
            
        imagemUsuario.image = image
            
    }
    
    
/*


// prgm mark ----

// convert images into base64 and keep them into string

func convertImageToBase64(image: UIImage) -> String {

var imageData = UIImagePNGRepresentation(image)
let base64String = imageData.base64EncodedStringWithOptions(.allZeros)

return base64String

}// end convertImageToBase64


// prgm mark ----

// convert images into base64 and keep them into string

func convertBase64ToImage(base64String: String) -> UIImage {

let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions(rawValue: 0) )

var decodedimage = UIImage(data: decodedData!)

return decodedimage!

}// end convertBase64ToImage


*/


    
 }
