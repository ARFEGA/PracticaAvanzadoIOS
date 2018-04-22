//
//  NotebookController+CreateNotebook.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 10/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//

import Foundation

import UIKit

extension NoteBookVC:CreateNewNoteBookVCDelegate{
    //Implementación delegado de CreateNewNoteBookVC
    func didEditNoteBook(Notebook NB: Notebook) {
        let row = NoteBookS.index(of: NB)
        let indexPathReload = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [indexPathReload], with: .automatic)
    }
    
    func didAddNoteBook(Notebook NB: Notebook) {
        addNoteBook(noteBook: NB)
    }
    
    private func addNoteBook(noteBook NB : Notebook){
        //NoteBookS.append(NB)
        
        //let newIndexPath = IndexPath(row: NoteBookS.count - 1, section: 4)
        //tableView.insertRows(at: [newIndexPath], with: .automatic)
        deleteTableView()
        getFetchedResultController()
        self.tableView.reloadData()
    }
}

// MARK: - Delegate
//Solicitud de trabajo delegado a NoteVC
extension NoteBookVC:NoteBookVCDelegate{
    func funcDelegateNoteBookVC(_ vc: NoteBookVC, didSelectNote note: Note) {
        let Note_VC = NoteVC()
        Note_VC.noteSended = note
        navigationController?.pushViewController(Note_VC, animated: true)
    }
}
