//
//  NoteVC+CreateView.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 18/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//

import  UIKit
import MapKit


extension CreateNewNoteVC{
    

    func setupView()  {
        viewContainer.addSubview(lblNameNote)
        lblNameNote.textColor = .white
        lblNameNote.text = "Name:"
        lblNameNote.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 0).isActive = true
        lblNameNote.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0).isActive = true
        lblNameNote.widthAnchor.constraint(equalToConstant: 110).isActive = true
        lblNameNote.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        viewContainer.addSubview(textNameNote)
        textNameNote.placeholder = "Name description"
        textNameNote.textColor = .white
        textNameNote.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 0).isActive = true
        textNameNote.leftAnchor.constraint(equalTo: lblNameNote.rightAnchor, constant: 10).isActive = true
        textNameNote.widthAnchor.constraint(equalToConstant: 130).isActive = true
        textNameNote.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
        viewContainer.addSubview(lblLimitDate)
        lblLimitDate.textColor = .white
        lblLimitDate.text = "Limit Date:"
        lblLimitDate.topAnchor.constraint(equalTo: lblNameNote.bottomAnchor, constant: 5).isActive = true
        lblLimitDate.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0).isActive = true
        lblLimitDate.widthAnchor.constraint(equalToConstant: 110).isActive = true
        lblLimitDate.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        viewContainer.addSubview(datePickerLimit)
        datePickerLimit.backgroundColor = UIColor.midleBlueGrey
        datePickerLimit.topAnchor.constraint(equalTo: lblLimitDate.bottomAnchor, constant: 2).isActive = true
        datePickerLimit.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0).isActive = true
        datePickerLimit.trailingAnchor.constraint(equalTo: textNameNote.trailingAnchor).isActive = true
        datePickerLimit.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        viewContainer.addSubview(lblTextDescription)
        lblTextDescription.textColor = .white
        lblTextDescription.text = "Description:"
        lblTextDescription.topAnchor.constraint(equalTo: datePickerLimit.bottomAnchor, constant: 2).isActive = true
        lblTextDescription.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0).isActive = true
        lblTextDescription.widthAnchor.constraint(equalToConstant: 110).isActive = true
        lblTextDescription.heightAnchor.constraint(equalToConstant: 20).isActive = true
       
        viewContainer.addSubview(textDescription)
       
        textDescription.topAnchor.constraint(equalTo: lblTextDescription.bottomAnchor , constant: 2).isActive = true
        textDescription.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor,constant: 0).isActive = true
        textDescription.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: 0).isActive = true
        textDescription.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor).isActive = true
        
        viewContainer.addSubview(uiimgNote)
        uiimgNote.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 0).isActive = true
        uiimgNote.leftAnchor.constraint(equalTo: datePickerLimit.rightAnchor, constant: 5).isActive = true
        uiimgNote.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -10).isActive = true
        uiimgNote.bottomAnchor.constraint(equalTo: datePickerLimit.bottomAnchor).isActive = true
        
        
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContainer)
        viewContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        viewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        viewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        viewContainer.heightAnchor.constraint(equalToConstant: view.frame.height / 3).isActive = true
        
        view.addSubview(mapView)
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        mapView.topAnchor.constraint(equalTo: viewContainer.bottomAnchor , constant: 5 ).isActive = true
    
    }
}
