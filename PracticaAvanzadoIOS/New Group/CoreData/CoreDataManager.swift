//
//  CoreDataManager.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 7/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//

import CoreData

struct CoreDataManager{
    //Will live forever as long as your application still alive.
    //it's properties will too
    static let shared = CoreDataManager()
    
    let persistentContainer : NSPersistentContainer={
        
        let container = NSPersistentContainer(name: "EverPobre")
        container.loadPersistentStores(completionHandler: { (storeDescription, err) in
            if let err = err{
                fatalError("Loading of store failed: \(err)")
            }
        })
        return container
    }()
    
    func fetchResultControllerNotebook() -> (NSFetchedResultsController<Notebook>?,Error?){
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Notebook>(entityName: "Notebook")
        let sortByTitle = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors=[sortByTitle]
        let NSFRC =  NSFetchedResultsController(fetchRequest: fetchRequest,managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        do{
            try NSFRC.performFetch()
            return (NSFRC,nil)
        }catch let errFetched{
            return (nil,errFetched)
        }
    }
    
    
    
    // MARK: Fetch NoteBook
    func fetchNotebook()->[Notebook]{
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Notebook>(entityName: "Notebook")
        do{
            return try context.fetch(fetchRequest)
        }catch let fetchErr{
            print(fetchErr)
        }
        return []
    }


    func saveChangesNotebook(){
        do{
            try persistentContainer.viewContext.save()
        }catch let err{
            print("Failed to delete notebook: \(err)")
        }
    }
    
    
    func getEntityNote() -> Note{
        let context = persistentContainer.viewContext
        //Creamos una nota
        return  NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
    }
    
    
    
    func recordNote(auxNote : Note) -> (Error?){
        let context = persistentContainer.viewContext
//        note = auxNote
//        note.myNotebook = auxNote.myNotebook
//        note.name = auxNote.name
//        note.creationDate = Date()
//        note.limitDate = auxNote.limitDate
//        note.textDescription = auxNote.textDescription
//        note.imageData = auxNote.imageData
        
        //note.setValue(name, forKey: "name")
        do{
            try context.save()
            return (nil)
        }catch let errSave{
            print(errSave)
            return (errSave)
        }
        
    }
}
