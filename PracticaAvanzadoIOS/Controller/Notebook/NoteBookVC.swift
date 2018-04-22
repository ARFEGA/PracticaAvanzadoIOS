//
//  NoteBookVC.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 2/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//

import UIKit
import CoreData


//AnyObject es lo mismp que class. Es necesaro que herede así para pode hacer una referencia weak
protocol NoteBookVCDelegate:AnyObject{
    func funcDelegateNoteBookVC(_ vc:NoteBookVC,didSelectNote:Note)
}

class NoteBookVC : UITableViewController,NSFetchedResultsControllerDelegate{
    var fetchedRC : NSFetchedResultsController<Notebook>?
    
    let cellID = "cellID"
    
    weak var delegate : NoteBookVCDelegate?
    
    var NoteBookS : [Notebook] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorStyle = .none
        title = "NOTEBOOK"
    
        // MARK: - Register Cell
        tableView.register(NoteBookCell.self, forCellReuseIdentifier: cellID)
        self.tableView.register(CustomHeader.self, forHeaderFooterViewReuseIdentifier: CustomHeader.reuseIdentifer)
        
        tableView.tableFooterView = UIView()
        
        //Creación de botones en main form
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset NBooks", style: .plain, target: self, action: #selector(handleReset))
        setupPlusButtonForNavBar(selector: #selector(newNoteBook))
        
        //Obtención de datos de CoreData
        getFetchedResultController()
        
        //Se subscribe a las notificaciones
        altaNotificaciones()
    }
    func deleteTableView(){
        var arraySections = [Int]()
        for x in 0..<NoteBookS.count{
            arraySections.append(x)
        }
        let indexSet = IndexSet(arraySections)
        NoteBookS = [Notebook]()
        tableView.deleteSections(indexSet, with: .fade)
    }
     func getFetchedResultController()
    {
        let tupla = CoreDataManager.shared.fetchResultControllerNotebook()
        if (tupla.1 != nil){
            return
        }else{
            fetchedRC = tupla.0
        }
        fetchedRC?.delegate = self
        //Ponemos a disposición  todos los objetos Notebook de CoreData
        guard let auxNoteBookS = fetchedRC?.fetchedObjects else {
            return
        }
        self.NoteBookS = auxNoteBookS
    }
    //Deleting all records in Core Data
    @objc private func handleReset(){
       
        let batchDeleteNotebooks = NSBatchDeleteRequest(fetchRequest: Notebook.fetchRequest())
        let context = CoreDataManager.shared.persistentContainer.viewContext
        do{
            //Borrado de datos en CoreData
            try context.execute(batchDeleteNotebooks)
            deleteTableView()
            return
            //Borrado de la tabla
            //Para añadir un efecto de salida hacia la izq. al eliminado de las filas en la tabla, haremos lo siguiente
            var indexPathToRemove = [IndexPath]()
            for(index,_) in NoteBookS.enumerated(){
                let indexPath = IndexPath(row: index, section: 0)
                indexPathToRemove.append(indexPath)
            }
            NoteBookS.removeAll()
            tableView.deleteRows(at: indexPathToRemove, with: .left)
            //Borrando y recargando de la siguiente manera, no tendríamos el efecto deseado de salida hacia la izquierda
            //tableView.reloadData()
        }catch let delErr{
            print("Failed deleting objects from core data \(delErr)")
        }
    }
    // Crea NoteBook
    @objc func newNoteBook(){
        let newNoteBookController = CreateNewNoteBookVC()
        newNoteBookController.delegate = self
        let navC = CustomNavController(rootViewController: newNoteBookController)
        present(navC, animated: true, completion: nil)
    }
    // Edit NoteBook
    @objc func editNoteBook(button : UIButtonBetter){
        let editNoteBookController = CreateNewNoteBookVC()
        editNoteBookController.Notebook = button.NB
        editNoteBookController.delegate = self
        let navC = CustomNavController(rootViewController: editNoteBookController)
        present(navC, animated: true, completion: nil)
    }
    // Delete NoteBook
    @objc func deleteNoteBook(button : UIButtonBetter){
        //Borramos el objeto de NoteBooks
        self.NoteBookS.remove(at: button.tag) //Se le pasa la sección dento de tag
        //Eliminamos la sección de la tabla
        let indexSet : IndexSet = IndexSet([button.tag])
        tableView.deleteSections(indexSet, with: .fade)
        //Remove from sqlite
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(button.NB!)
        CoreDataManager.shared.saveChangesNotebook()
    }
}







