//
//  JuegosViewController.swift
//  ColeccionDeJuegos
//
//  Created by Maria Cutipa on 6/05/24.
//

import UIKit

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var JuegoImageView: UIImageView!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var eliminarBoton: UIButton!
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    @IBOutlet weak var categoriaPickerView: UIPickerView!
    var imagePicker = UIImagePickerController()
    var juego:Juego? = nil
    var categorias: [Categoria] = []
    
    @IBAction func eliminarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(juego!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func cameraTapped(_ sender: Any) {
    }
    @IBAction func agregarTapped(_ sender: Any) {
        if juego != nil {
            juego!.titulo! = tituloTextField.text!
            juego!.imagen = JuegoImageView.image?.jpegData(compressionQuality: 0.50)
            juego!.categoria = categorias[categoriaPickerView.selectedRow(inComponent: 0)].nombre
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juego = Juego(context: context)
            juego.titulo = tituloTextField.text
            juego.imagen = JuegoImageView.image?.jpegData(compressionQuality: 0.50)
            juego.categoria = categorias[categoriaPickerView.selectedRow(inComponent: 0)].nombre
        }

        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        categoriaPickerView.dataSource = self
        categoriaPickerView.delegate = self
        cargarCategorias()
        cargarCategorias()
        
        if juego != nil {
            JuegoImageView.image = UIImage(data: (juego!.imagen!) as Data)
            tituloTextField.text = juego!.titulo
            agregarActualizarBoton.setTitle("Actualizar", for: .normal)
            if let index = categorias.firstIndex(where: { $0.nombre == juego!.categoria }) {
                categoriaPickerView.selectRow(index, inComponent: 0, animated: false)
            }
            
        }else{
            eliminarBoton.isHidden = true
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenSeleccionada = info[.originalImage] as? UIImage
        JuegoImageView.image = imagenSeleccionada
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorias.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let categoria = categorias[row]
        return categoria.nombre // Suponiendo que el nombre de la categoría está almacenado en la propiedad `nombre`
    }

    func cargarCategorias() {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                categorias = try context.fetch(Categoria.fetchRequest()) as [Categoria] // Obtener todas las categorías
                categoriaPickerView.reloadAllComponents() // Recargar los componentes del picker view
            } catch {
                print("Error al cargar categorías: \(error.localizedDescription)")
            }
        }
}
