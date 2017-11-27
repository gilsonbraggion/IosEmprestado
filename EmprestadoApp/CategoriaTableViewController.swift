import UIKit
import Alamofire

var categorias = [Categoria]()
var celulaCategoria = "CelulaCategoria"

var categoriaSelecionada : Categoria = Categoria()

class CategoriaTableViewController: UITableViewController {
    
    @IBOutlet var tabela: UITableView!
    let userNameKeyConstant = "userNameKey"
    
    override func viewWillAppear(_ animated: Bool) {       

        let defaults = UserDefaults.standard
        defaults.string(forKey: "userName")
        defaults.string(forKey: "userMail")
        defaults.string(forKey: "idUser")

        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        buscarCategoria { (str) in
            if str.count > 0 {
                self.tabela.reloadData()
            } else {
                print("Lista Vazia")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()       
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorias.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var celula = tableView.dequeueReusableCell(withIdentifier: celulaCategoria) as UITableViewCell!
        
        if (celula == nil) {
            celula = UITableViewCell(style: UITableViewCellStyle.default , reuseIdentifier: celulaCategoria)
        }
        
        let categoria = categorias[indexPath.row]
        celula?.textLabel!.text = categoria.nome

        return celula!
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let mais = UITableViewRowAction(style: .normal, title: "Mais") { action, index in
            
            categoriaSelecionada = categorias[indexPath.row]
            
            self.opcoesCategoria(self)

        }
        mais.backgroundColor = UIColor.lightGray
        
        return [mais]

    }
    
    
    @IBAction func adicionarCategoria(_ sender: AnyObject) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "",
            message: "Insira o nome de sua categoria!", preferredStyle: .alert)
        
        // Criando um botão cancelar
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) {
            action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        // Criando um botao com a ação de gravar
        let nextAction: UIAlertAction = UIAlertAction(title: "Gravar", style: .default) {
            action -> Void in
            
            let text = actionSheetController.textFields?.first?.text
            self.salvarCategoria(text!)
            
        }
        
        actionSheetController.addAction(nextAction)
        // Criando o campo de texto a ser exibido
        actionSheetController.addTextField {
            campoNome -> Void in
            // Cor do texto que será digitado
            campoNome.textColor = UIColor.blue
        }
        
        // Apresentando o campo
        self.present(actionSheetController, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (categorias.count > 0) {
            // Enviar o dado que está no Array e não na tabela.
            if segue.identifier == "segueToItem" {
                if let destination = segue.destination as? ItemTableViewController {
                    if let indexTabela = tabela.indexPathForSelectedRow?.row {
                        
                        let categoria = categorias[indexTabela]
                        destination.categoria = categoria
                    }
                }
            }
        }
    }
    
    func salvarCategoria(_ nomeCategoria : String) {
        
        if Reachability.isConnectedToNetwork() == true {
            
            let parameters = [
                "nome": "\(nomeCategoria)"
            ]
            
            let urlJson = "\(Endereco().enderecoConexao)/categoria/adicionar"
            
            Alamofire.request(.POST, urlJson, parameters : parameters)
                .responseJSON { response in
                    
                let retorno =  response.2.value as! NSDictionary;

                let categoria : Categoria = Categoria();
                categoria.id = retorno.valueForKey("id") as! String
                categoria.nome = retorno.valueForKey("nome") as! String
                
                categorias.append(categoria)
                self.tabela.reloadData()
            }
            
        } else {
            
            let alert = AlertIntert.getAlert();
            alert.show()
            
        }
        
    }
    
    func buscarCategoria(_ completionHandler: @escaping ([Categoria]) -> ()) -> () {
        categorias.removeAll(keepingCapacity: true)
        
        if Conectividade.isConnectedToNetwork() == true {
            let urlJson = "\(Endereco().enderecoConexao)/categoria/buscar"
            
            Alamofire.request(.GET, urlJson)
                .responseJSON { response in
                
                let retorno =  response.2.value as! NSArray;
                
                for cat in retorno {
                    
                    let categoria : Categoria = Categoria();
                    categoria.id = cat.valueForKey("id") as! String
                    categoria.nome = cat.valueForKey("nome") as! String
                    
                    categorias.append(categoria)
                }
                
                completionHandler(categorias)
            }
        } else {
            
            let alert = AlertIntert.getAlert();
            alert.show()
            
        }

    }
    
    func opcoesCategoria(_ sender: AnyObject) {

        let actionSheetController: UIAlertController = UIAlertController(title: "Opções Categoria", message: "Escolha uma opção!", preferredStyle: .actionSheet)
        
        // Criação do botão editar
        let editarAction: UIAlertAction = UIAlertAction(title: "Editar", style: .destructive) { action -> Void in

            let editarCategoria = self.storyboard!.instantiateViewController(withIdentifier: "EditarCategoriaViewController") as! EditarCategoriaViewController
            
            editarCategoria.categoria = categoriaSelecionada
            self.navigationController!.pushViewController(editarCategoria, animated: true)

        }
        actionSheetController.addAction(editarAction)
        
        // Criação do botão opções
        let opcoesAction: UIAlertAction = UIAlertAction(title: "Opções", style: .default) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(opcoesAction)

        
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
