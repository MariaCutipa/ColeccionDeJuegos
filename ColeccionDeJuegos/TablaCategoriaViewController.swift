//
//  TablaCategoriaViewController.swift
//  ColeccionDeJuegos
//
//  Created by Maria Cutipa on 10/05/24.
//

import UIKit

class TablaCategoriaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableCategorias: UITableView!
    var categorias :[Categoria] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let categoria = categorias[indexPath.row]
        cell.textLabel?.text = categoria.nombre
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let categoria = categorias[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(categoria)
            do {
                try context.save()
                categorias.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Error deleting game: \(error)")
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableCategorias.dataSource = self
        tableCategorias.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try categorias = context.fetch(Categoria.fetchRequest())
            tableCategorias.reloadData()
        }catch{
            
        }
    }


}
