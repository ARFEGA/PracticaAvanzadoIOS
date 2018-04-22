//
//  NoteVC.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 17/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Contacts

class NoteVC: UIViewController {
    var noteSended : Note?{
        didSet{
            //label.text = self.noteBookCell?.name
            if let img =  noteSended?.imageData {
                uiimgNote.image = UIImage(data:img)
            }
            if let name = noteSended?.name{
                textNameNote.text = name
            }
            if let dateCreation = noteSended?.creationDate {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "dd/MM/yy"
                textFieldCreationDate.text =   dateFormater.string(from: dateCreation)
                //Par tratar la fecha en formato local
                //let locale = Locale(identifier: "ES")
                //let stringDateCreation = dateCreation.description(with: locale)
            }
            if let limitDate = noteSended?.limitDate {
                datePickerLimit.date =   limitDate
            }
            if let textD = noteSended?.textDescription {
                textDescription.text =   textD
            }
            if let lat = noteSended?.latitude , let long = noteSended?.longitude{
                
                //Create annotation an show on the map
                let annotetion = MKPointAnnotation()
                annotetion.title = noteSended?.lugar
                annotetion.coordinate = CLLocationCoordinate2DMake(lat, long)
                self.mapView.addAnnotation(annotetion)
                
                //Make zooming in on annotation
                let span = MKCoordinateSpanMake(0.04,0.04 )
                let region = MKCoordinateRegionMake(annotetion.coordinate, span)
                self.mapView.setRegion(region, animated: true)
                
            }
            
        }
    }

    let cellId = "cellId"
    
    
    var lblNameNote = UILabel().getCustomLabel()
    var lblCreationDate = UILabel().getCustomLabel()
    var lblLimitDate = UILabel().getCustomLabel()
    var textNameNote = UITextField().getCustomTextField()
    var textFieldCreationDate = UITextField().getCustomTextField()
    var datePickerLimit = UIDatePicker().getCustomDatePicker()
    var lblTextDescription = UILabel().getCustomLabel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Alta en notificaciones
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: Notification.Name(rawValue: NOTE_SAVED), object: nil, queue: OperationQueue.main) { (notification) in
            // userInfo is the payload send by sender of notification
            if let userInfo = notification.userInfo {
                // Safely unwrap the name sent out by the notification sender
                //self.notes.append(userInfo[NOTE_KEY] as! Note)
                self.noteSended = (userInfo[NOTE_KEY] as! Note)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightBlue
        guard let NB = noteSended?.myNotebook else{return}
        navigationItem.title  = "NoteBook : \(String(describing: NB.name ?? ""))"
        setupPlusButtonForNavBar(selector: #selector(handleNewNote))
        createSwipGesture()
        setupUI()
    }
    private func createSwipGesture(){
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeGestureRight.direction = .right
        uiimgNote.addGestureRecognizer(swipeGestureRight)
        
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeGestureRight.direction = .left
        uiimgNote.addGestureRecognizer(swipeGestureLeft)
        uiimgNote.isUserInteractionEnabled = true
        let swipeGestureDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeGestureDown.direction = .down
        uiimgNote.addGestureRecognizer(swipeGestureDown)
        uiimgNote.isUserInteractionEnabled = true
        let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeGestureUp.direction = .up
        uiimgNote.addGestureRecognizer(swipeGestureUp)
        uiimgNote.isUserInteractionEnabled = true
   
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(respondOneTapGesture))
        oneTap.numberOfTapsRequired = 1
        uiimgNote.addGestureRecognizer(oneTap)
        
        let twoTap = UITapGestureRecognizer(target: self, action: #selector(respondTwoTapGesture))
        twoTap.numberOfTapsRequired = 2
        uiimgNote.addGestureRecognizer(twoTap)
        
        
        uiimgNote.isUserInteractionEnabled = true
    }
    var tapMade : Bool = false
    
    @objc func respondOneTapGesture(gesture: UITapGestureRecognizer){
        if tapMade{
            self.uiimgNote.transform = CGAffineTransform.identity
        }
        tapMade = true
        self.uiimgNote.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @objc func respondTwoTapGesture(gesture: UITapGestureRecognizer){
        if tapMade{
            self.uiimgNote.transform = CGAffineTransform.identity
        }
        tapMade = true
        self.uiimgNote.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    let lblInfRotate = UILabel().getCustomLabel()
    let  btnRotateRight : UIButton = {
        var btn = UIButton()
        btn.setBackgroundImage(#imageLiteral(resourceName: "rotarDerecha"), for: UIControlState.normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = 90
        btn.addTarget(self, action: #selector(handlerRotationByButton) , for: .touchUpInside)
        return btn
    }()
    let btnRotateLeft : UIButton = {
        var btn = UIButton()
        btn.setBackgroundImage(#imageLiteral(resourceName: "rotarIzquierda"), for: UIControlState.normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = -90
        btn.addTarget(self, action: #selector(handlerRotationByButton) , for: .touchUpInside)
        return btn
    }()
  
    let uiimgNote : UIImageView={
        var uiimage = UIImageView()
        uiimage.image = #imageLiteral(resourceName: "select_photo_empty")
        uiimage.contentMode = .scaleAspectFill
        uiimage.translatesAutoresizingMaskIntoConstraints = false
        //Forma redondeada de la imagen
        uiimage.layer.cornerRadius = 20
        uiimage.clipsToBounds = true
        return uiimage
    }()
    
    
    var textDescription : UITextView = {
        let tView = UITextView()
        tView.backgroundColor = UIColor.darkBlue
        tView.textColor = .white
        tView.translatesAutoresizingMaskIntoConstraints = false
        return tView
    }()
    
    var mapView : MKMapView = {
        var map = MKMapView()
        map.setRegion(MKCoordinateRegion.init(center: CLLocationCoordinate2D.init(latitude:40.40,longitude:-3.7), span: MKCoordinateSpan.init(latitudeDelta: 0.04, longitudeDelta: 0.04)), animated: false)
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private func setupUI(){
        
        var viewTransparente = UIView()
        
        
        
        view.addSubview(lblNameNote)
        lblNameNote.text = "Name Note:"
        lblNameNote.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        lblNameNote.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        lblNameNote.widthAnchor.constraint(equalToConstant: 110).isActive = true
        lblNameNote.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(textNameNote)
        textNameNote.isEnabled = false
        textNameNote.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        textNameNote.leftAnchor.constraint(equalTo: lblNameNote.rightAnchor, constant: 10).isActive = true
        textNameNote.widthAnchor.constraint(equalToConstant: 130).isActive = true
        textNameNote.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        view.addSubview(lblCreationDate)
        lblCreationDate.text = "Creation Date:"
        lblCreationDate.topAnchor.constraint(equalTo: lblNameNote.bottomAnchor, constant: 5).isActive = true
        lblCreationDate.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        lblCreationDate.widthAnchor.constraint(equalToConstant: 110).isActive = true
        lblCreationDate.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(textFieldCreationDate)
        textFieldCreationDate.isEnabled = false
        textFieldCreationDate.topAnchor.constraint(equalTo: textNameNote.bottomAnchor, constant: 5).isActive = true
        textFieldCreationDate.leftAnchor.constraint(equalTo: lblCreationDate.rightAnchor, constant: 10).isActive = true
        textFieldCreationDate.widthAnchor.constraint(equalToConstant: 130).isActive = true
        textFieldCreationDate.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(lblLimitDate)
        lblLimitDate.text = "Limit Date:"
        lblLimitDate.topAnchor.constraint(equalTo: lblCreationDate.bottomAnchor, constant: 5).isActive = true
        lblLimitDate.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        lblLimitDate.widthAnchor.constraint(equalToConstant: 110).isActive = true
        lblLimitDate.heightAnchor.constraint(equalToConstant: 20).isActive = true
       
        view.addSubview(datePickerLimit)
        datePickerLimit.isEnabled = false
        datePickerLimit.topAnchor.constraint(equalTo: lblLimitDate.bottomAnchor, constant: 2).isActive = true
        datePickerLimit.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        datePickerLimit.trailingAnchor.constraint(equalTo: textFieldCreationDate.trailingAnchor).isActive = true
        datePickerLimit.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        view.addSubview(mapView)
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: (view.frame.height / 2.75)).isActive = true
        
        
        view.addSubview(lblTextDescription)
        lblTextDescription.text = "Description:"
        textDescription.isEditable = false
        lblTextDescription.topAnchor.constraint(equalTo: datePickerLimit.bottomAnchor, constant: 2).isActive = true
        lblTextDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        lblTextDescription.widthAnchor.constraint(equalToConstant: 110).isActive = true
        lblTextDescription.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(textDescription)
        textDescription.topAnchor.constraint(equalTo: lblTextDescription.bottomAnchor , constant: 2).isActive = true
        textDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
        textDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        textDescription.bottomAnchor.constraint(equalTo: mapView.topAnchor , constant: -5).isActive = true
        
        
        view.addSubview(uiimgNote)
        uiimgNote.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        uiimgNote.leftAnchor.constraint(equalTo: datePickerLimit.rightAnchor, constant: 5).isActive = true
        uiimgNote.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        uiimgNote.bottomAnchor.constraint(equalTo: textDescription.topAnchor, constant: -2).isActive = true
        
       
        
        view.addSubview(btnRotateLeft)
        btnRotateLeft.leftAnchor.constraint(equalTo: uiimgNote.leftAnchor).isActive = true
        btnRotateLeft.bottomAnchor.constraint(equalTo: uiimgNote.topAnchor, constant: -1).isActive = true
        btnRotateLeft.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnRotateLeft.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
       
        
        view.addSubview(btnRotateRight)
        btnRotateRight.rightAnchor.constraint(equalTo: uiimgNote.rightAnchor).isActive = true
        btnRotateRight.bottomAnchor.constraint(equalTo: uiimgNote.topAnchor, constant: -1).isActive = true
        btnRotateRight.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnRotateRight.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(lblInfRotate)
        lblInfRotate.textColor = .black
        lblInfRotate.font = UIFont.boldSystemFont(ofSize: 10)
        lblInfRotate.numberOfLines = 0
        lblInfRotate.textAlignment = .center
        lblInfRotate.text = "Enabled arrows or gestures"
        lblInfRotate.translatesAutoresizingMaskIntoConstraints = false
        lblInfRotate.leadingAnchor.constraint(equalTo: btnRotateLeft.trailingAnchor).isActive = true
        lblInfRotate.trailingAnchor.constraint(equalTo: btnRotateRight.leadingAnchor).isActive = true
        lblInfRotate.bottomAnchor.constraint(equalTo: uiimgNote.topAnchor, constant: -1).isActive = true
        lblInfRotate.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        
    }
    @objc private func handleNewNote(){
        // TODO: Resolver el alta de nota desde el formulario NoteVC
                print ("Probando a crear nueva nota")
                let newNoteVC = CreateNewNoteVC()
                newNoteVC.notebook_Note = noteSended?.myNotebook
                let navController = UINavigationController(rootViewController: newNoteVC)
                present(navController, animated: true, completion:nil)
    }
  
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
        
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                handlerRotationBySwipGesture(degrees: CGFloat(90))
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            handlerRotationBySwipGesture(degrees: CGFloat(90))
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
               handlerRotationBySwipGesture(degrees: CGFloat(90))
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                handlerRotationBySwipGesture(degrees: CGFloat(90))
            default:
                break
            }
        }
    }
    func handlerRotationBySwipGesture(degrees : CGFloat){
        UIView.animate(withDuration: 1.0, animations: {
            self.uiimgNote.transform =  self.uiimgNote.transform.rotated(by: (degrees * .pi / 180))
            print(self.uiimgNote.frame)
        
        })
    }
        
    @objc func handlerRotationByButton(btn : UIButton){
        //https://guides.codepath.com/ios/Using-View-Transforms#applying-a-translation-transform
        let value : CGFloat
        value = CGFloat(btn.tag)
        UIView.animate(withDuration: 1.0, animations: {
            //self.uiimgNote.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.uiimgNote.transform =  self.uiimgNote.transform.rotated(by: (value * .pi / 180))
        })
        //UIView.animate(withDuration: 2.0, animations: {self.uiimgNote.transform = CGAffineTransform(scaleX: 2, y: 2)})
        //UIView.animate(withDuration: 2.0, animations: {self.uiimgNote.transform = CGAffineTransform(translationX: -256, y: -256)})
        //UIView.animate(withDuration: 2.0, animations: {self.uiimgNote.transform = CGAffineTransform(rotationAngle: (CGFloat.pi * CGFloat(-1.0)))})
         //UIView.animate(withDuration: 2.0, animations: {self.uiimgNote.transform = CGAffineTransform.identity})
        
//        UIView.animate(withDuration: 1.0, animations: {
//            self.uiimgNote.transform = CGAffineTransform(rotationAngle: (value * .pi) / 180)
//        })
        //self.uiimgNote.transform = self.uiimgNote.transform.rotated(by:(value * .pi) / 180)
       
    }
  
    
    
    
    
    private func FetchNote(){
        //        guard let arrayNotes = noteSended?.notes?.allObjects as? [Note] else {return}
        //        self.notes = arrayNotes
        //        let context = CoreDataManager.shared.persistentContainer.viewContext
        //        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        //        do{
        //            self.notes = try context.fetch(fetchRequest)
        //        }catch let err{
        //            print(err)
        //        }
        
    }
}

// Funciones delegadas
//Un view controller solo puede ser delegado de otor. En este caso he intentado que lo sea de dos por lo que esta función, no opera
extension NoteVC:CreateNewNoteVCDelegate{
    func noteDidSaved(note: Note) {
        noteSended = note
        
    }
}
//Funciona correctamente
extension NoteVC:NoteBookVCDelegate{
    func funcDelegateNoteBookVC(_ vc: NoteBookVC, didSelectNote noteSelected: Note) {
        navigationItem.title = noteSelected.name
        noteSended = noteSelected
        //navigationItem.title  = "NoteBook : \(String(describing: NB.name ?? ""))"
        setupPlusButtonForNavBar(selector: #selector(handleNewNote))
        createSwipGesture()
        setupUI()
    }
}




