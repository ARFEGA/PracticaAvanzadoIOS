//
//  CreateNoteController.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 10/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//

import UIKit
import MapKit


let NOTE_SAVED = "NoteSaved"
let NOTE_KEY = "NoteKey"


protocol CreateNewNoteVCDelegate: AnyObject {
    func noteDidSaved(note:Note)
}

class CreateNewNoteVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UISearchBarDelegate{
    var  notebook_Note : Notebook?
    weak var delegate : CreateNewNoteVCDelegate?
    
    var noteSended : Note?{
        didSet{
            guard let note = noteSended else {
                return
            }
            if let img =  note.imageData {
                uiimgNote.image = UIImage(data:img)
            }
            if let name = note.name{
                textNameNote.text = name
            }
            
            if let limitDate = note.limitDate {
                datePickerLimit.date =   limitDate
            }
            if let textD = note.textDescription {
                textDescription.text =   textD
            }
            if let lat = noteSended?.latitude , let long = noteSended?.longitude{
                mapView.setRegion(MKCoordinateRegion.init(center: CLLocationCoordinate2D.init(latitude:lat,longitude:long), span: MKCoordinateSpan.init(latitudeDelta: 0.04, longitudeDelta: 0.04)), animated: false)
                //Create annotation an show on the map
                let annotetion = MKPointAnnotation()
                annotetion.title = note.lugar
                annotetion.coordinate = CLLocationCoordinate2DMake(lat, long)
                self.mapView.addAnnotation(annotetion)
                
                //Make zooming in on annotation
                let span = MKCoordinateSpanMake(0.04,0.04 )
                let region = MKCoordinateRegionMake(annotetion.coordinate, span)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }

    let viewContainer = UIView()
    let lblNameNote = UILabel().getCustomLabel()
    let lblLimitDate = UILabel().getCustomLabel()
    let textNameNote = UITextField().getCustomTextField()
    let textFieldLimitDate = UITextField().getCustomTextField()
    var datePickerLimit = UIDatePicker().getCustomDatePicker()
    var lblTextDescription = UILabel().getCustomLabel()
    var tapGesture : UITapGestureRecognizer?
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture = UITapGestureRecognizer(target: self , action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture!)
        setupCancelButton()
        navigationItem.title = "New Note"
        view.backgroundColor = UIColor.midleBlueGrey
        setupView()
        setupCircularImg()
        let btnSave = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        let btnsearch = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchView))
        navigationItem.rightBarButtonItems = [btnSave,btnsearch]
    }
    @objc private func dismissKeyboard(sender : UITapGestureRecognizer ){
        self.view.endEditing(true)
    }
    @objc func searchView(btn : UIBarButtonItem){
        let searchController  = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barTintColor = navigationController?.navigationBar.barTintColor
        searchController.searchBar.tintColor = self.view.tintColor
        searchController.loadViewIfNeeded()
        definesPresentationContext = true
        present(searchController, animated: true)
        {
            UIView.animate(withDuration: 2.0, animations: { self.viewContainer.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)})
        }
    
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 1.0, animations: {self.viewContainer.transform = CGAffineTransform.identity})
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Enter")
        //Bloquear al user
        UIApplication.shared.beginIgnoringInteractionEvents()
        //Creamos un activity indicator
        let ai = UIActivityIndicatorView()
        ai.activityIndicatorViewStyle = .gray
        ai.center = mapView.center
        ai.hidesWhenStopped = true
        ai.stopAnimating()
        
        self.view.addSubview(ai)
        
        //Ocultar searchBar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Crear la busqueda
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            ai.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if (error != nil){
                //TODO ALERT
                print(error)
            }else{
                //remove annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                //Getting data
                guard let lat = response?.boundingRegion.center.latitude else {/*TODO Alert*/return}
                guard let lon = response?.boundingRegion.center.longitude else {/*TODO Alert*/return}
                
                //Create annotation an show on the map
                let annotetion = MKPointAnnotation()
                annotetion.title = searchBar.text
                annotetion.coordinate = CLLocationCoordinate2DMake(lat, lon)
                self.mapView.addAnnotation(annotetion)
               
                //Make zooming in on annotation
                let span = MKCoordinateSpanMake(0.04,0.04 )
                let region = MKCoordinateRegionMake(annotetion.coordinate, span)
                self.mapView.setRegion(region, animated: true)
                
                 UIView.animate(withDuration: 2.0, animations: { self.viewContainer.transform = CGAffineTransform.identity})
                
            }
        }
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("DidEndEditing")
    }

    //Declare with lazy var is necesary to do that GestureRecognize work correctly
    lazy var uiimgNote : UIImageView={
        let imgView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        //The next is very important to allow user select a photo. Remember to do this.
        imgView.isUserInteractionEnabled = true
        //Now we going to add Gesture
        imgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhotoNB)))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
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
            uiimgNote.image = imgOriginal
        }else if let imgEdited = info[UIImagePickerControllerEditedImage] as? UIImage{
            uiimgNote.image = imgEdited
        }
        setupCircularImg()
        dismiss(animated: true, completion: nil)
    }
    
    
    let textDescription : UITextView = {
        let tView = UITextView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        return tView
    }()
    
    let mapView : MKMapView = {
        let map = MKMapView()
        map.setRegion(MKCoordinateRegion.init(center: CLLocationCoordinate2D.init(latitude:40.40,longitude:-3.7), span: MKCoordinateSpan.init(latitudeDelta: 0.04, longitudeDelta: 0.04)), animated: false)
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
   
    private func setupCircularImg(){
        uiimgNote.layer.cornerRadius = uiimgNote.frame.width / 2
        uiimgNote.clipsToBounds = true
        uiimgNote.layer.borderColor = UIColor.darkBlue.cgColor
    }
    
    @objc func handleSave(){
        var CreateNote = Bool()
       
        if textNameNote.text != nil &&  textNameNote.text != "" {
            if self.noteSended == nil {
                noteSended = CoreDataManager.shared.getEntityNote()
                CreateNote = true
            }
            noteSended?.name = textNameNote.text
            noteSended?.creationDate = Date()
            if let img = uiimgNote.image{
                let imgData = UIImageJPEGRepresentation(img, 1)
                noteSended?.imageData = imgData
            }
            noteSended?.limitDate = datePickerLimit.date
            
            noteSended?.textDescription = textDescription.text
            if let lat = mapView.annotations.last?.coordinate.latitude, let long = mapView.annotations.last?.coordinate.longitude  {
                noteSended?.latitude = lat
                noteSended?.longitude = long
                noteSended?.lugar = mapView.annotations.last?.title ?? ""
            }
            noteSended?.myNotebook = self.notebook_Note
            //guard let auxNote = noteSended else{ return}
            saveNote(CreateNote: CreateNote, auxNote: noteSended!)
        }else{
            //TODO ALERT NECESARIO VALOR NOMBRE NOTA
            print("Error, no hay nombre de nota")
        }
    }
    private func saveNote(CreateNote: Bool,auxNote : Note){
        if CreateNote {
            var newNote = CoreDataManager.shared.getEntityNote()
            newNote = auxNote
            if let error = CoreDataManager.shared.recordNote(auxNote: newNote){
                //TODO
                //Mostrar a través de un alert el error
                print(error)
                return
            }
            notiyChangeNote(auxNote: newNote)
            
        }else{//"Update":
                CoreDataManager.shared.saveChangesNotebook()
                notiyChangeNote(auxNote: auxNote)
        }
        
    }
    private func notiyChangeNote(auxNote : Note){
        dismiss(animated: true, completion: {
            self.delegate?.noteDidSaved(note: auxNote)
            
            let notificationCenter=NotificationCenter.default
            let notification=Notification(name: Notification.Name(NOTE_SAVED), object: self,userInfo: [NOTE_KEY:auxNote])
            notificationCenter.post(notification)
        })
    }
}

extension CreateNewNoteVC: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerCoord = mapView.centerCoordinate
        let location = CLLocation(latitude: centerCoord.latitude, longitude: centerCoord.longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placeMarkArray, error) in
            if let places = placeMarkArray {
                if let place = places.first{
                    DispatchQueue.main.async{
                        print("\(place.postalAddress!.street), \(place.postalAddress!.city)")
                    }
                }
            }
        }
    }
}
