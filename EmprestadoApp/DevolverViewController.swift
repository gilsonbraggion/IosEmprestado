import UIKit
import Alamofire

class DevolverViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dataDevolucao: UITextField!
    
    @IBOutlet weak var labelItem: UILabel!
    @IBOutlet weak var btnRetornar: UIButton!
    @IBOutlet weak var labelMensagem: UILabel!
    
    var item : Item = Item()
    
    var end : Endereco = Endereco()
    
    override func viewWillAppear(_ animated: Bool) {
        datePicker.isHidden = true
        btnRetornar.layer.cornerRadius  = 10
        
        labelItem.text = item.nome
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataDevolucao.addTarget(self , action: #selector(DevolverViewController.focoCampoData(_:)), for: UIControlEvents.allEvents)
        
        datePicker.addTarget(self, action: #selector(DevolverViewController.selecionarData(_:)), for: UIControlEvents.valueChanged)

    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        datePicker.isHidden = true
        self.view.endEditing(true)
    }
    
    @IBAction func devolverItem(_ sender: AnyObject) {
        if dataDevolucao.text!.isEmpty {
            labelMensagem.isHidden = false
            labelMensagem.text = "Preencha todos os campos."
        } else {
            salvarDevolucao();
        }
    }

    
    func focoCampoData(_ campo : UITextField) {
        datePicker.isHidden = false
        self.view.endEditing(true)
    }
    
    func selecionarData(_ datePicker:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dataDevolucao.text = dateFormatter.string(from: datePicker.date)
        labelMensagem.isHidden = true
    }
    
    func salvarDevolucao() {
        
        let parameters = [
            "idItem": "\(item.id)",
            "dataDevolucao": "\(dataDevolucao.text!)",
        ]
        
        let urlJson = "\(Endereco().enderecoConexao)/emprestimo/retornar"
        
        Alamofire.request(.POST, urlJson, parameters : parameters)
            .responseJSON { response in
            
            let listagemEmprestimos = self.storyboard!.instantiateViewControllerWithIdentifier("EmprestadosViewController") as! EmprestadosTableViewController
            
            self.navigationController!.pushViewController(listagemEmprestimos, animated: true)
            
        }
    }



}
