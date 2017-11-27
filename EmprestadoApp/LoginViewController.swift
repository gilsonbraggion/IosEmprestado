import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var btnFacebook: FBSDKLoginButton!
    
    let userNameKeyConstant = "userNameKey"
    var logado = false;
    
    override func viewWillAppear(_ animated: Bool) {
        returnUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (FBSDKAccessToken.current() != nil) {
            logado = true
            
        } else {
            btnFacebook.readPermissions = ["public_profile", "email", "user_friends"]
            btnFacebook.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        redirecionar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Facebook Delegate Methods
    func loginButton(_ loginButton: FBSDKLoginButton!,
        didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!) {
            
            if ((error) != nil) {
                // Handle cancellations
            } else if result.isCancelled {
                // Handle cancellations
            } else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if result.grantedPermissions.contains("email") {
                    // Do work
                }
            }
            
            logado = true
            returnUserData()
            
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil) {
                // Process error
//                print: \(error)")
                
            } else {
                
//                prprintUsuário :  \(result)")
                
                let idUser : NSString = result.value(forKey: "id") as! NSString
//                prprintID : \(idUser)")
                
                let userName : NSString = result.value(forKey: "name") as! NSString
//                println("Nome : \(userName)")
                
                var email: AnyObject? = result.value(forKey: "email")
                
                if (email != nil) {
                    email = email as! String as AnyObject
                } else {
                    email = "" as AnyObject
                }
                
                let defaults = UserDefaults.standard
                defaults.set(userName, forKey: "userName")
                defaults.set(email, forKey: "userMail")
                defaults.set(idUser, forKey: "idUser")
                
            }
        })
        
        redirecionar()
    }
    
    func redirecionar() {
        if logado {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "TabBarId") as! TabBarController
            self.present(next, animated: true, completion: nil)
        }
    }
    
}

