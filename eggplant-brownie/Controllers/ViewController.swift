//
//  ViewController.swift
//  eggplant-brownie
//
//  Created by HirvinFaria on 08/11/20.
//

import UIKit

protocol AdicionaRefeicaoDelegate {
    func add(_ refeicao: Refeicao)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AdicionarItensDelegate {
    
    // MARK: - Atributos
    
    var delegate: AdicionaRefeicaoDelegate?
    var itens: Array<Item> = []
    var itensSelecionados: Array<Item> = []
    
    // MARK: - Metodos
    
    

    // MARK: - IBOutlet
    
    @IBOutlet weak var nomeTextField: UITextField?
    @IBOutlet weak var felicidadeTextField: UITextField?
    @IBOutlet weak var itensTableView: UITableView?
    
    // MARK: - IBAction
    
    @IBAction func adicionar() {
        
        if let refeicao = recuperaRefeicao() {
            delegate?.add(refeicao)
            navigationController?.popViewController(animated: true)
        } else {
            Alerta(controller: self).exibe(mensagem: "Erro ao ler dados do formulário")
        }
    }
    
    func recuperaRefeicao() -> Refeicao? {
        guard let nomeDaRefeicao = nomeTextField?.text else {
            return nil
        }
        
        guard let felicidade = felicidadeTextField?.text,
              let felicidadeDaRefeicao = Int(felicidade) else {
              return nil
        }
        
        let refeicao: Refeicao = Refeicao(nome: nomeDaRefeicao, felicidade: felicidadeDaRefeicao, itens: itensSelecionados)
        
        return refeicao
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
//      titulo do botão
//      estilo do botão
//      local do metodo do botão
//      ação do metodo do botão
        let botaoAdicionaItem = UIBarButtonItem(title: "Adicionar", style: .plain, target: self, action: #selector(adicionarItem))
        navigationItem.rightBarButtonItem = botaoAdicionaItem

        itens = ItensDao().recupera()
    }
    
    @objc func adicionarItem(){
        let adicionarItensViewController = AdicionarItensViewController(delegate: self)
        navigationController?.pushViewController(adicionarItensViewController, animated: true)
    }
    
    func add(_ item: Item) {
        itens.append(item)
        // itensTableView?.reloadData()
        if let tableView = itensTableView {
            tableView.reloadData()
        } else {
            Alerta(controller: self).exibe(titulo: "Desculpe", mensagem: "Não foi possivel atualizar a tabela")
        }
        
        ItensDao().save(itens)
    }
    
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let item = itens[indexPath.row]
        
        celula.textLabel?.text = item.nome
        
        return celula
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let celula = tableView.cellForRow(at: indexPath) else { return }
        
        if celula.accessoryType == .none {
            celula.accessoryType = .checkmark
            let linhaDaTabela = indexPath.row
            itensSelecionados.append(itens[linhaDaTabela])
        } else {
            celula.accessoryType = .none
            
            let item = itens[indexPath.row]
            if let position = itensSelecionados.firstIndex(of: item) {
                itensSelecionados.remove(at: position)
            }
        }

    }

}

