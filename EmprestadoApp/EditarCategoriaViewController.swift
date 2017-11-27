import UIKit
import Alamofire

class EditarCategoriaViewController: UIViewController {

    var categoria : Categoria = Categoria()
    
    @IBOutlet weak var inputCategoria: UITextField!
   
    @IBOutlet weak var labelCategoria: UILabel!
    
    @IBOutlet weak var botaoSalvar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelCategoria.text = categoria.nome
        botaoSalvar.layer.cornerRadius  = 10

    }

    @IBAction func editarCategoria(_ sender: AnyObject) {
        
        if Reachability.isConnectedToNetwork() == true {
            
            let parameters = [
                "nome": "\(inputCategoria.text!)",
                "id": "\(categoria.id)",
            ]
            
            let urlJson = "\(Endereco().enderecoConexao)/categoria/editar"
            
            Alamofire.request(.POST, urlJson, parameters : parameters)
                .responseJSON { response in
                    
                if response.2.isSuccess {
                    let editarCategoria = self.storyboard!.instantiateViewControllerWithIdentifier("Categorias") as! CategoriaTableViewController
                    
                    self.dismissViewControllerAnimated(false, completion: {})
                    self.navigationController!.pushViewController(editarCategoria, animated: true)

                }
            }
        } else {
            let alert = AlertIntert.getAlert();
            alert.show()
        }
        
    }
}
