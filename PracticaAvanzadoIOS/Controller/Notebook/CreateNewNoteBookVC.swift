//
//  CreaNewNoteBookVC.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 6/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//

import UIKit
import CoreData

//Delegado personalizado

protocol CreateNewNoteBookVCDelegate:AnyObject {
    
    func didAddNoteBook(Notebook NB: Notebook)
    func didEditNoteBook(Notebook NB : Notebook)
}



class CreateNewNoteBookVC:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let context = CoreDataManager.shared.persistentContainer.viewContext
    weak var delegate : CreateNewNoteBookVCDelegate?
    var tapGesture : UITapGestureRecognizer?
    
    var Notebook : Notebook? {
        didSet{
            textName.text = Notebook?.name
            if let  img = Notebook?.imageData{
                notebookImageView.image = UIImage(data: img)
                //Pone uiimagecontroller de forma coircular
                setupCircularImg()
            }
            guard let created = Notebook?.creationDate else {return}
            datePicker.date = created
        }
    }
   
    
    let lblImage =  UILabel().getCustomLabel()
    //Declare with lazy var is necesary to do that GestureRecognize work correctly
    lazy var notebookImageView: UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        //The next is very important to allow user select a photo. Remember to do this.
        imgView.isUserInteractionEnabled = true
        //Now we going to add Gesture
        imgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhotoNB)))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    let nameLabel : UILabel={
        let label = UILabel()
        label.text = "Name:"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let textName : UITextField = {
        let `text` = UITextField()
        text.placeholder = "   Insert name"
        text.backgroundColor = UIColor.lightGray
        text.textColor = .white
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    let lblDatePicker = UILabel().getCustomLabel()
    let datePicker = UIDatePicker().getCustomDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //When tap out textbox dismmiss keyboard
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        //self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGesture!)
        
        setupCancelButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        view.backgroundColor = UIColor.darkBlue
        
        setupUI()
    }
    @objc private func dismissKeyboard(sender : UITapGestureRecognizer ){
        self.view.endEditing(true)
    }
    
    private func setupCircularImg(){
        notebookImageView.layer.cornerRadius = notebookImageView.frame.width / 2
        notebookImageView.clipsToBounds = true
        notebookImageView.layer.borderColor = UIColor.darkBlue.cgColor
    }
    
    @objc private func handleSelectPhotoNB(){
        print ("Trying to select a photo..")
        let imgPickerC = UIImagePickerController()
        imgPickerC.delegate = self
        //Allow to edit the photo
        imgPickerC.allowsEditing = true
        present(imgPickerC, animated: true, completion: nil)
        
    }
    //ImagePicker delegate methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //If the img is original without have been edited
        if let imgOriginal = info[UIImagePickerControllerOriginalImage] as? UIImage{
            notebookImageView.image = imgOriginal
        }else if let imgEdited = info[UIImagePickerControllerEditedImage] as? UIImage{
            notebookImageView.image = imgEdited
        }
        setupCircularImg()
        dismiss(animated: true, completion: nil)
    }
    
    
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = self.Notebook != nil ? "Edit Notebook" : "New NoteBook"
    }
    
  
    
    @objc func handleSave(){
        guard  let _ = Notebook else{createNotebook(); return}
        saveNotebookChanges()
    }
   
    private func saveNotebookChanges(){
        Notebook?.name = textName.text
        Notebook?.creationDate = datePicker.date
        
        if let imageNB = notebookImageView.image {
            let imgData = UIImageJPEGRepresentation(imageNB, 1)
            Notebook?.imageData = imgData
        }
        
        saveContext(inContext: self.context)
        dismiss(animated: true) {
            self.delegate?.didEditNoteBook(Notebook: self.Notebook!)
        }
    }
    
    private func createNotebook(){
        let noteBook = NSEntityDescription.insertNewObject(forEntityName: "Notebook", into: context)
        
        guard  let name = self.textName.text else {return}
        if name != ""{
            noteBook.setValue(name, forKey: "name")
            noteBook.setValue(datePicker.date, forKey: "creationDate")
            
            if let imageNB = notebookImageView.image {
                let imgData = UIImageJPEGRepresentation(imageNB, 1)
                noteBook.setValue(imgData, forKey: "imageData")
            }
            
            // perform the save
            do{
                try context.save()
                dismiss(animated: true){
                    self.delegate?.didAddNoteBook(Notebook: noteBook as! Notebook)
                }
            }catch let err{
                print(err)
            }
        }else{
            //TODO ALERT
        }
    }
    
   
    
    //MARK: Layout
    private func setupUI(){
        
        //let backView = setupBackBlueView(height: 350)
        view.addSubview(lblImage)
        lblImage.textColor = .white
        lblImage.text = "Image:"
        lblImage.font = UIFont.boldSystemFont(ofSize: 20)
        lblImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive=true
        lblImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        lblImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        lblImage.heightAnchor.constraint(equalToConstant: 50).isActive=true
        
        
        view.addSubview(notebookImageView)
        notebookImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive=true
        notebookImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10).isActive=true
        notebookImageView.leadingAnchor.constraint(equalTo: lblImage.trailingAnchor ).isActive = true
        notebookImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
       
        
        view.addSubview(nameLabel)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.topAnchor.constraint(equalTo: notebookImageView.bottomAnchor, constant : 10).isActive=true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive=true
        
        view.addSubview(textName)
        textName.topAnchor.constraint(equalTo: notebookImageView.bottomAnchor, constant : 10).isActive=true
        textName.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        textName.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10).isActive=true
        textName.heightAnchor.constraint(equalToConstant: 50).isActive=true
        textName.layer.cornerRadius = 25
        
        view.addSubview(lblDatePicker)
        lblDatePicker.textColor = .white
        lblDatePicker.text = "Date:"
        lblDatePicker.font = UIFont.boldSystemFont(ofSize: 20)
        lblDatePicker.topAnchor.constraint(equalTo: textName.bottomAnchor, constant : 10).isActive=true
        lblDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        lblDatePicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        lblDatePicker.heightAnchor.constraint(equalToConstant: 50).isActive=true
        
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: textName.bottomAnchor, constant : 10).isActive=true
        datePicker.leadingAnchor.constraint(equalTo: lblDatePicker.trailingAnchor).isActive=true
        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant : -10).isActive=true
        datePicker.heightAnchor.constraint(equalToConstant: view.frame.height / 3).isActive=true
    }
}

// MARK: - Save CoreData changes

extension CreateNewNoteBookVC{
    func saveContext(inContext:NSManagedObjectContext){
        do{
            try inContext.save()
        }catch let err{
            print("Failed to delete notebook: \(err)")
        }
    }
}
