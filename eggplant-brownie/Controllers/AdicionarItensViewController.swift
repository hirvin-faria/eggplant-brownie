//
//  AdicionarItensViewController.swift
//  eggplant-brownie
//
//  Created by HirvinFaria on 15/11/20.
//

import UIKit

protocol AdicionarItensDelegate {
    func add(_ item: Item)
}

class AdicionarItensViewController: UIViewController {
    
    // MARK: - Atributos
    var delegate: AdicionarItensDelegate?
    
    init(delegate: AdicionarItensDelegate) {
        super.init(nibName: "AdicionarItensViewController", bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var caloriasTextField: UITextField!
    
    
    // MARK: - IBAction
    
    @IBAction func adicionarItem(_ sender: Any) {
        
        if let nome = nomeTextField.text,
           let caloriasText = caloriasTextField.text,
           let calorias = Double(caloriasText) {
                let item = Item(nome: nome, calorias: calorias)
                delegate?.add(item)
                navigationController?.popViewController(animated: true)
        }
    }
}
