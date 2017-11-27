import UIKit
import Alamofire

var emprestados = [Emprestimo]()
var celulaEmprestados = "CelulaEmprestados"

class EmprestadosTableViewController: UITableViewController {
    
    var categoria : Categoria = Categoria()

    @IBOutlet var tabela: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        buscarEmprestados { (str) in
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
        return emprestados.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var celula :  UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: celulaEmprestados) as UITableViewCell!
        
        if (celula == nil) {
            celula = UITableViewCell(style: UITableViewCellStyle.default , reuseIdentifier: celulaEmprestados)
        }
        
        let emprestado = emprestados[indexPath.row]
        celula.textLabel!.text = emprestado.responsavel
        
        return celula
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Enviar o dado que está no Array e não na tabela.
        if segue.identifier == "segueToDetalhe" {
            if let destination = segue.destination as? DetalheViewController {
                
                if let indexTabela = tabela.indexPathForSelectedRow?.row {
                let emprestado = emprestados[indexTabela]
                    
                    buscarItem(emprestado.idItem) { (item) in
                        destination.item = item
                    }
                    
                    buscarCategoria(emprestado.idCategoria) { (categoria) in
                        destination.categoria = categoria
                    }
                    
                    destination.responsavel = emprestado.responsavel
                
                }

            }
        }

    }
    
    func buscarEmprestados(_ completionHandler: @escaping ([Emprestimo]) -> ()) -> () {
        emprestados.removeAll(keepingCapacity: true)
        
        let urlJson = "\(Endereco().enderecoConexao)/emprestimo/buscar"
        Alamofire.request(.GET, urlJson).responseJSON { JSON in
            
            let retorno =  JSON.2.value as! NSArray;
            
            for emp in retorno {
                
                let emprestimo : Emprestimo = Emprestimo();
                emprestimo.id = emp.valueForKey("id") as! String
                emprestimo.responsavel = emp.valueForKey("responsavel") as! String
                emprestimo.idItem = emp.valueForKey("idItem") as! String
                emprestimo.idCategoria = emp.valueForKey("idCategoria") as! String
                
                emprestados.append(emprestimo)
            }
            
            completionHandler(emprestados)
        }
    }

    func buscarItem(_ idItem: String, completionHandler: @escaping (Item) -> ()) -> () {
        
        let urlJson = "\(Endereco().enderecoConexao)/item/obter/\(idItem)"
        
        Alamofire.request(.GET, urlJson).responseJSON { JSON in
            
            let retorno =  JSON.2.value as! NSDictionary;
            
                let item : Item = Item();
                item.id = retorno.valueForKey("id") as! String
                item.nome = retorno.valueForKey("nome") as! String
                item.idCategoria = retorno.valueForKey("idCategoria") as! String
            
            completionHandler(item)
        }
    }
    
    func buscarCategoria(_ idCategoria: String, completionHandler: @escaping (Categoria) -> ()) -> () {
        
        let urlJson = "\(Endereco().enderecoConexao)/categoria/obter/\(idCategoria)"
        Alamofire.request(.GET, urlJson).responseJSON { JSON in
            
            let retorno =  JSON.2.value as! NSDictionary;
            
            let categoria : Categoria = Categoria();
            categoria.id = retorno.valueForKey("id") as! String
            categoria.nome = retorno.valueForKey("nome") as! String
            
            completionHandler(categoria)
        }
    }


}
