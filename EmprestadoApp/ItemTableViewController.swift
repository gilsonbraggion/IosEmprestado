import UIKit
import Alamofire

var itens = [Item]()
var celulaItem = "CelulaItem"

class ItemTableViewController: UITableViewController {
    
    @IBOutlet var tabelaItem: UITableView!
    
    var categoria : Categoria = Categoria()
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        buscarItens { (lista) in
            if lista.count > 0 {
                self.tabelaItem.reloadData()
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
        return itens.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var celula :  UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: celulaItem) as UITableViewCell!
        
        if (celula == nil) {
            celula = UITableViewCell(style: UITableViewCellStyle.default , reuseIdentifier: celulaItem)
        }
        
        let item = itens[indexPath.row]
        celula.textLabel!.text = item.nome
        
        return celula
    }
    
    @IBAction func adicionarItem(_ sender: AnyObject) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "",
            message: "Insira o nome de seu item!", preferredStyle: .alert)
        
        // Criando um botão cancelar
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) {
            action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        // Criando um botao com a ação de gravar
        let nextAction: UIAlertAction = UIAlertAction(title: "Gravar", style: .default) {
            action -> Void in
            
            let text = actionSheetController.textFields?.first?.text
            self.salvarItem(text!)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (itens.count > 0) {
            // Enviar o dado que está no Array e não na tabela.
            if segue.identifier == "segueToDetalhe" {
                if let destination = segue.destination as? DetalheViewController {
                    if let indexTabela = tabelaItem.indexPathForSelectedRow?.row {
                        
                        let item = itens[indexTabela]
                        destination.item = item
                        destination.categoria = categoria
                        
                    }
                }
            }
        }
    }
    
    func salvarItem(_ nomeItem : String) {
        
        if Reachability.isConnectedToNetwork() == true {
            
            let parameters = [
                "nome": "\(nomeItem)",
                "idCategoria": "\(categoria.id)"
            ]
            
            let urlJson = "\(Endereco().enderecoConexao)/item/adicionar"
            
            Alamofire.request(.POST, urlJson, parameters : parameters)
                .responseJSON { response in
                    
                    let retorno =  response.2.value as! NSDictionary;
                    
                    let item : Item = Item();
                    item.id = retorno.valueForKey("id") as! String
                    item.nome = retorno.valueForKey("nome") as! String
                    item.idCategoria = retorno.valueForKey("idCategoria") as! String
                    
                    itens.append(item)
                    self.tabelaItem.reloadData()
            }
            
        } else {
            
            let alert = AlertIntert.getAlert();
            alert.show()
            
        }
        
        
    }
    
    func buscarItens(_ completionHandler: @escaping ([Item]) -> ()) -> () {
        itens.removeAll(keepingCapacity: true)
        
        let urlJson = "\(Endereco().enderecoConexao)/item/buscar/\(categoria.id)"
        
        Alamofire.request(.GET, urlJson)
            .responseJSON { response in
                
                let retorno =  response.2.value as! NSArray;
                
                for it in retorno {
                    
                    let item : Item = Item();
                    item.id = it.valueForKey("id") as! String
                    item.nome = it.valueForKey("nome") as! String
                    item.idCategoria = it.valueForKey("idCategoria") as! String
                    
                    itens.append(item)
                }
                
                completionHandler(itens)
        }
    }

    
}
