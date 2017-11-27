import UIKit

open class AlertIntert {
    
    class func getAlert() -> UIAlertView {
        let alert = UIAlertView(title: "Sem internet", message: "Certifique-se que seu aparelho tem conexão com a internet.", delegate: nil, cancelButtonTitle: "OK")
        
        return alert;
        
    }
}
