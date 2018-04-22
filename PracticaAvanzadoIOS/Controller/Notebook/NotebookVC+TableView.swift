//
//  NotebookVC+TableView.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 10/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//

import UIKit

// MARK: - Table
extension NoteBookVC{
    // TEXTO PARA EL PIE DE TABLA
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No Notebooks available......"
        label.textColor = UIColor.darkBlue
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }
    // ALTO DEL PIE DE TABLA
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return NoteBookS.count == 0 ? 150 : 0
    }
    
   
    
    //ADDED BUTTON ACTIONS
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let Notes = NoteBookS[indexPath.section].notes?.allObjects as! [Note]
        let selectedNote = Notes[indexPath.row]
        //let selectedNB = NoteBookS[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            //Remove de Notbook from de array and from the tableview
            //self.NoteBookS.remove(at: indexPath.row)
            self.NoteBookS[indexPath.section].removeFromNotes(selectedNote)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //Remove from sqlite
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(selectedNote)
            CoreDataManager.shared.saveChangesNotebook()
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editNote)
        deleteAction.backgroundColor = .lightRed
        editAction.backgroundColor = .darkBlue
        
        return [deleteAction,editAction]
    }
    private func editNote(action : UITableViewRowAction,indexPath: IndexPath){
        let editNoteVC = CreateNewNoteVC()
        editNoteVC.notebook_Note = NoteBookS[indexPath.section]
        let Notes = NoteBookS[indexPath.section].notes!.allObjects
        editNoteVC.noteSended = (Notes[indexPath.row] as! Note)
        let navVC = CustomNavController(rootViewController: editNoteVC)
        
        present(navVC, animated: true,completion: nil)
    }
//    private func editNotebook(action : UITableViewRowAction,indexPath: IndexPath){
//        let editNotebookVC = CreateNewNoteBookVC()
//        editNotebookVC.Notebook = NoteBookS[indexPath.row]
//        editNotebookVC.delegate = self
//        let navVC = CustomNavController(rootViewController: editNotebookVC)
//        present(navVC, animated: true,completion: nil)
//    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleSection = NoteBookS[section].name ?? ""
        let NB = NoteBookS[section]
        return setupHeaderSection(titleSection: titleSection, section: section,NB: NB)
        
    }
    
    func setupHeaderSection(titleSection: String , section : Int, NB : Notebook) -> UIView?{
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeader.reuseIdentifer) as? CustomHeader else {
            return nil
        }
        let margin = header.contentView.layoutMarginsGuide
       
        
       
        
        //Colapse Section
        let buttonClose = UIButtonBetter(type: .system)
        buttonClose.setTitle( "Close", for: .normal)
        buttonClose.setTitleColor(.white, for: .normal)
        buttonClose.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        buttonClose.tag = section
        buttonClose.translatesAutoresizingMaskIntoConstraints = false
        header.contentView.addSubview(buttonClose)
        buttonClose.leftAnchor.constraint(equalTo: margin.leftAnchor).isActive = true
        buttonClose.widthAnchor.constraint(equalToConstant: 40).isActive=true
        buttonClose.topAnchor.constraint(equalTo: margin.topAnchor).isActive=true
        buttonClose.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive=true
        buttonClose.NB = NB
        buttonClose.addTarget(self, action: #selector(handlerExpandCloseHeader), for: .touchUpInside)
        
        //Edit Section
        let buttonEdit = UIButtonBetter(type: .system)
        buttonEdit.setTitle( "Edit", for: .normal)
        buttonEdit.setTitleColor(.white, for: .normal)
        buttonEdit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        buttonEdit.tag = section
        buttonEdit.translatesAutoresizingMaskIntoConstraints = false
        header.contentView.addSubview(buttonEdit)
        buttonEdit.leadingAnchor.constraint(equalTo: buttonClose.trailingAnchor).isActive = true
        buttonEdit.widthAnchor.constraint(equalToConstant: 40).isActive=true
        buttonEdit.topAnchor.constraint(equalTo: margin.topAnchor).isActive=true
        buttonEdit.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive=true
        buttonEdit.NB = NB
        buttonEdit.addTarget(self, action: #selector(editNoteBook), for: .touchUpInside)
        
        //Delete Section
        let buttonDelete = UIButtonBetter(type: .system)
        buttonDelete.setTitle( "Delete", for: .normal)
        buttonDelete.setTitleColor(.white, for: .normal)
        buttonDelete.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        buttonDelete.tag = section
        buttonDelete.translatesAutoresizingMaskIntoConstraints = false
        header.contentView.addSubview(buttonDelete)
        buttonDelete.leadingAnchor.constraint(equalTo: buttonEdit.trailingAnchor).isActive = true
        buttonDelete.widthAnchor.constraint(equalToConstant: 50).isActive=true
        buttonDelete.topAnchor.constraint(equalTo: margin.topAnchor).isActive=true
        buttonDelete.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive=true
        buttonDelete.NB = NB
        buttonDelete.addTarget(self, action: #selector(deleteNoteBook), for: .touchUpInside)
        
        //Add Note
        let buttonAdd = UIButtonBetter(type: .system)
        buttonAdd.setTitle( "+Note", for: .normal)
        buttonAdd.setTitleColor(.white, for: .normal)
        buttonAdd.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        buttonAdd.translatesAutoresizingMaskIntoConstraints = false
        buttonAdd.tag = section
        header.contentView.addSubview(buttonAdd)
        buttonAdd.rightAnchor.constraint(equalTo: margin.rightAnchor).isActive = true
        buttonAdd.widthAnchor.constraint(equalToConstant: 45).isActive=true
        buttonAdd.topAnchor.constraint(equalTo: margin.topAnchor).isActive=true
        buttonAdd.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive=true
        buttonAdd.NB = NB
        buttonAdd.addTarget(self, action: #selector(self.handlerNewNote) , for: .touchUpInside)
        
        //Name NoteBook
        let customLabel = UILabel.init()
        customLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        customLabel.text = titleSection
        customLabel.textAlignment = .center
        header.contentView.addSubview(customLabel)
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        customLabel.leadingAnchor.constraint(equalTo: buttonDelete.trailingAnchor).isActive = true
        customLabel.trailingAnchor.constraint(equalTo: buttonAdd.leadingAnchor).isActive = true
        customLabel.topAnchor.constraint(equalTo: margin.topAnchor).isActive = true
        customLabel.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive = true
        return header
    }
    
    //Metodo para crear nueva nota desde pantalla de NoteBook
    @objc func handlerNewNote(button : UIButtonBetter){
            print ("Probando a crear nueva nota")
            let newNoteVC = CreateNewNoteVC()
            newNoteVC.notebook_Note = button.NB
            let navController = UINavigationController(rootViewController: newNoteVC)
            present(navController, animated: true, completion:nil)
    }
    
    
    //Metodo utilizado para contraer y expandir las secciones
    @objc func handlerExpandCloseHeader(button : UIButton){
        let section = button.tag
        var indexPath = [IndexPath]()
        
     
        guard let rows = NoteBookS[section].notes?.count else {return}
        for row in 0..<rows{
            let auxIndexPAth = IndexPath(row: row, section: section)
            indexPath.append(auxIndexPAth)
        }
        let isExpanded = !NoteBookS[section].isExpandable
        NoteBookS[section].isExpandable =  isExpanded
        
        if isExpanded {
            //tableView.v
            tableView.insertRows(at: indexPath, with: .right)
        }else
        {
            tableView.deleteRows(at: indexPath, with: .fade)
        }
        //twoD[section].names.removeAll()
        
    }

   
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 //Alto de la fila
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return NoteBookS.count
        return NoteBookS.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            //guard let sections = fetchedRC.fetchedObjects else { return 0}
            guard let rows = NoteBookS[section].notes?.count else { return 0}
            return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Section: \(indexPath.section) Row: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NoteBookCell
//        let imgView = UIImageView(image: #imageLiteral(resourceName: "fondo_celda1.png"))
//        cell.backgroundView = imgView
//        let NB = NoteBookS[indexPath.row]
//        let notes = NB.notes?.allObjects as? [Note]
//        guard let notess = notes else {
//            return cell
//        }
//      cell.noteBookCell = NB
        //notess.forEach{print("Note name: " , $0.name ?? "")}
       
        if(NoteBookS.count == 0){
            return cell
        }
        guard let notes = NoteBookS[indexPath.section].notes?.allObjects  as? [Note] else{
            return cell
        }
        if(notes.count == 0){
            return cell
        }
        //cell.textLabel?.text = notes[indexPath.row].name
        cell.noteCell = notes[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notes = NoteBookS[indexPath.section].notes?.allObjects  as? [Note]
        let note = notes![indexPath.row]
        delegate?.funcDelegateNoteBookVC(self, didSelectNote: note)
    }
    
}

