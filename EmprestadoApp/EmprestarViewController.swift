import UIKit
import Alamofire

class EmprestarViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var labelMensagem: UILabel!

    @IBOutlet weak var botaoEmprestar: UIButton!
    
    let focoCampoData = "focoCampoData:";
    
    @IBOutlet weak var campoResponsavel: UITextField!
    @IBOutlet weak var dataPrevistaDevolucao: UITextField!
    @IBOutlet weak var dataEmprestimo: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var labelItem: UILabel!
    
    var campoSelecionado : UITextField = UITextField()
    
    var item : Item = Item()
    
    override func viewWillAppear(_ animated: Bool) {
        datePicker.isHidden = true
        botaoEmprestar.layer.cornerRadius  = 10

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataEmprestimo.addTarget(self , action: Selector(focoCampoData), for: UIControlEvents.allEvents)
        dataPrevistaDevolucao.addTarget(self , action: Selector(focoCampoData), for: UIControlEvents.allEvents)
        
        datePicker.addTarget(self, action: #selector(EmprestarViewController.selecionarData(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    @IBAction func emprestarItem(_ sender: AnyObject) {
        if campoResponsavel.text!.isEmpty || dataEmprestimo.text!.isEmpty || dataPrevistaDevolucao.text!.isEmpty {
            labelMensagem.isHidden = false
            labelMensagem.text = "Preencha todos os campos."
        } else {
            salvarEmprestimo();
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        datePicker.isHidden = true
        self.view.endEditing(true)
    }
    
    
    func focoCampoData(_ campo : UITextField) {
        let identificadorCampo = campo.restorationIdentifier
        
        if (identificadorCampo?.hasPrefix("data") != nil) {
            campoSelecionado = campo
            datePicker.isHidden = false
            self.view.endEditing(true)
        }

    }

    func selecionarData(_ datePicker:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let s = dateFormatter.string(from: datePicker.date)
        campoSelecionado.text = s
    }
    
    func salvarEmprestimo() {
        
        let parameters = [
            "idItem": "\(item.id)",
            "responsavel": "\(campoResponsavel.text!)",
            "dataEmprestimo": "\(dataEmprestimo.text!)",
            "dataPrevistaDevolucao": "\(dataPrevistaDevolucao.text!)"
        ]
        
        let urlJson = "\(Endereco().enderecoConexao)/emprestimo/adicionar"
        Alamofire.request(.POST, urlJson, parameters: parameters).responseJSON {JSON in
            
            let listagemEmprestimos = self.storyboard!.instantiateViewControllerWithIdentifier("EmprestadosViewController") as! EmprestadosTableViewController
            
            self.dismissViewControllerAnimated(true, completion: {})
            self.navigationController!.pushViewController(listagemEmprestimos, animated: true)
            
        }
    }
    
}
