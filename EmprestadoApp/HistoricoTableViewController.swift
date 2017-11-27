import UIKit
import Alamofire

var emprestimos = [Emprestimo]()
var celulaHistorico = "CelulaHistorico"

class HistoricoTableViewController: UITableViewController {
    
    var item = Item()
    
    let basicCellIdentifier = "CelulaHistorico"
    
    @IBOutlet var tabelaHistorico: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        buscarHistorico { (lista) in
            if lista.count > 0 {
                self.tabelaHistorico.reloadData()
            } else {
                print("Lista Vazia")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    func configureTableView() {
        tabelaHistorico.rowHeight = UITableViewAutomaticDimension
        tabelaHistorico.estimatedRowHeight = 135.0
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emprestimos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return basicCellAtIndexPath(indexPath)

    }
    
    func basicCellAtIndexPath(_ indexPath:IndexPath) -> HistoricoTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: basicCellIdentifier) as! HistoricoTableViewCell
        
        setDataEmprestimo(cell, indexPath: indexPath)
        setResponsavel(cell, indexPath: indexPath)
        setDataDevolucao(cell, indexPath: indexPath)
        
        return cell
    }
    
    func setDataEmprestimo(_ cell:HistoricoTableViewCell, indexPath:IndexPath) {
        let dataEmprestimo = emprestimos[indexPath.row].dataEmprestimo
        
        cell.dataEmprestimo.text = "Data empréstimo : \(dataEmprestimo)"
        
    }
    
    func setResponsavel(_ cell:HistoricoTableViewCell, indexPath:IndexPath) {
        let item = emprestimos[indexPath.row].responsavel
        cell.responsavel.text = "Responsável: \(item) "
    }
    
    func setDataDevolucao(_ cell:HistoricoTableViewCell, indexPath:IndexPath) {
        
        let dataDevolucao = emprestimos[indexPath.row].dataDevolucao
        let dataPrevistaDevolucao = emprestimos[indexPath.row].dataPrevistaDevolucao
        
        if dataDevolucao.isEmpty {
          cell.dataDevolucao.text = "Data prevista Devolucão : \(dataPrevistaDevolucao) "
        } else {
          cell.dataDevolucao.text = "Data de Devolucão : \(dataDevolucao) "
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (emprestimos.count > 0) {
            // Enviar o dado que está no Array e não na tabela.
            if segue.identifier == "segueToDetalhe" {
                if let _ = segue.destination as? DetalheViewController {
                    if let indexTabela = tabelaHistorico.indexPathForSelectedRow?.row {
                        
                        let emprestimo = emprestimos[indexTabela]
                        item.id = emprestimo.idItem
                        
                        buscarItem { (item) in
                            if item.id != "" {
                                self.tabelaHistorico.reloadData()
                            } else {
                                print("")
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    
    func buscarItem(_ completionHandler: @escaping (Item) -> ()) -> () {
        
        let item : Item = Item();
        
        _ = "\(Endereco().enderecoConexao)/item/buscar/\(item.id)"
        
        
        Alamofire.request(.GET, "http://httpbin.org/get")
            .responseJSON { JSON in
                
                let retorno =  JSON.2.value as! NSArray;
                
                for it in retorno {
                    
                    item.id = it.valueForKey("id") as! String
                    item.nome = it.valueForKey("nome") as! String
                    item.idCategoria = it.valueForKey("idCategoria") as! String
                    
                }
                
                completionHandler(item)
                
        }
        
    }
    
    
    func buscarHistorico(_ completionHandler: @escaping ([Emprestimo]) -> ()) -> () {
        emprestimos.removeAll(keepingCapacity: true)
        
        let urlJson = "\(Endereco().enderecoConexao)/emprestimo/buscar/\(item.id)"
        Alamofire.request(.GET, urlJson).responseJSON {JSON in
            
            let retorno =  JSON.2.value as! NSArray;
            
            for it in retorno {
                
                let item : Emprestimo = Emprestimo();
                item.id = it.valueForKey("id") as! String
                
                item.dataEmprestimo = it.valueForKey("dataEmprestimo") as! String
                
                let dataDevolucao: AnyObject? = it.valueForKey("dataDevolucao")
                if (dataDevolucao != nil) {
                    item.dataDevolucao = dataDevolucao as! String
                }
                
                item.dataPrevistaDevolucao = it.valueForKey("dataPrevistaDevolucao") as! String
                
                item.responsavel = it.valueForKey("responsavel") as! String
                item.idItem = it.valueForKey("idItem") as! String
                
                emprestimos.append(item)
            }
            
            completionHandler(emprestimos)
        }
    }
    
    
}
