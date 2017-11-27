import UIKit
import Alamofire

class DetalheViewController: UIViewController {
    
    @IBOutlet weak var editarBotao: UIBarButtonItem!
    
    @IBOutlet weak var labelEmprestado: UILabel!
    @IBOutlet weak var labelResponsavel: UILabel!
    
    @IBOutlet weak var labelCategoria: UILabel!
    
    @IBOutlet weak var labelItem: UILabel!
    
    @IBOutlet weak var btnHistorico: UIButton!
    @IBOutlet weak var btnEmprestar: UIButton! = UIButton()
    
    @IBOutlet weak var btnDevolver: UIButton! = UIButton()
    
    var item : Item = Item()
    var categoria : Categoria = Categoria()
    var emprestado : Emprestimo = Emprestimo()
    var responsavel = ""

    
    override func viewWillAppear(_ animated: Bool) {

        self.labelResponsavel.isHidden = true
        self.labelEmprestado.isHidden = true

        self.btnDevolver.layer.cornerRadius = 10
        self.btnEmprestar.layer.cornerRadius = 10
        self.btnHistorico.layer.cornerRadius = 10
        
        verificarItemEmprestado {(emprestado) in
            if emprestado {
                self.btnEmprestar.isHidden = true
                self.btnDevolver.isHidden = false
                self.labelEmprestado.isHidden = false
                self.labelResponsavel.isHidden = false
            } else {
                self.btnEmprestar.isHidden = false
                self.btnDevolver.isHidden = true
                self.labelResponsavel.isHidden = true
                self.labelEmprestado.isHidden = true
            }
            
            
            if !self.responsavel.isEmpty {
                self.labelResponsavel.isHidden = false
                self.labelEmprestado.isHidden = false
            }
            
            
            self.labelCategoria.text = self.categoria.nome
            self.labelItem.text = self.item.nome
            self.labelResponsavel.text = self.responsavel
            
        }


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToEmprestar" {
            if let destination = segue.destination as? EmprestarViewController {
                destination.item = self.item
            }
        }
        
        // Arrumar
        if segue.identifier == "segueToDevolver" {
            if let destination = segue.destination as? DevolverViewController {
                destination.item = self.item
            }
        }
        // Arrumar
        if segue.identifier == "segueToHistorico" {
            if let destination = segue.destination as? HistoricoTableViewController {
                destination.item = self.item
            }
        }
        
    }
    
    func verificarItemEmprestado(_ completionHandler: @escaping (Bool) -> ()) -> () {
        
        if Reachability.isConnectedToNetwork() == true {
            
            let urlJson = "\(Endereco().enderecoConexao)/emprestimo/verificarItemEmprestado/\(item.id)"
            
            Alamofire.request(.GET, urlJson).responseJSON { response in
                    
                    var retorno : Bool = false
                    
                    if response.2.isSuccess {
                        let dicionario = response.2.value as! NSDictionary
                        
                        if dicionario.valueForKey("id") as! String != "vazio" {
                            retorno = true
                            let emprestimo = Emprestimo()
                            emprestimo.id = dicionario.valueForKey("id") as! String
                            emprestimo.responsavel = dicionario.valueForKey("responsavel") as! String
                            
                            self.emprestado = emprestimo
                            self.responsavel = self.emprestado.responsavel
                            self.labelResponsavel.text = self.emprestado.responsavel
                        }
                        
                    }
                
                    completionHandler(retorno)
            }
            
        } else {
            let alert = AlertIntert.getAlert();
            alert.show()
        }
        
    }

    @IBAction func opcoesItem(_ sender: AnyObject) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Opções Item", message: "Escolha uma opção!", preferredStyle: .actionSheet)
        
        // Criação do botão editar
        let editarAction: UIAlertAction = UIAlertAction(title: "Editar", style: .destructive) { action -> Void in
            
        }
        actionSheetController.addAction(editarAction)
        
        // Criação do botão opções
        let tirarFoto: UIAlertAction = UIAlertAction(title: "Tirar foto", style: .default) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(tirarFoto)

        // Criação do botão opções
        let selecionarFoto: UIAlertAction = UIAlertAction(title: "Selecionar foto", style: .default) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(selecionarFoto)

        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        
        //We need to provide a popover sourceView when using it on iPad
        actionSheetController.popoverPresentationController?.sourceView = (sender as! UIView);
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
    

    
}
