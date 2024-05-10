//
//  CategoriasViewController.swift
//  ColeccionDeJuegos
//
//  Created by Maria Cutipa on 10/05/24.
//

import UIKit

class CategoriasViewController: UIViewController {

    @IBOutlet weak var categoriaTextField: UITextField!
    @IBAction func agregarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let categoria = Categoria(context: context)
        categoria.nombre = categoriaTextField.text
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}


