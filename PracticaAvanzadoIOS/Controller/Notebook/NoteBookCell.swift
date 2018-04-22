//
//  notebookCell.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 9/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//

import UIKit

class NoteBookCell: UITableViewCell {
    
    var noteCell : Note?{
        didSet{
            guard let note = noteCell else {return}
            
            lblNota.text = note.name ?? ""
            if let img =  note.imageData {
                uiimgNB.image = UIImage(data:img)
            }
            if let limitDate = note.limitDate {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "dd/MMM/yyyy"
                let stringDateLimit = dateFormater.string(from: limitDate)
                lbldate.text = "Limit Date on:\(stringDateLimit)"
            }
        }
    }
    
    let lblNota = UILabel().getCustomLabel()
    let lbldate = UILabel().getCustomLabel()
    let uiimgNB : UIImageView={
        var uiimage = UIImageView()
        uiimage.image = #imageLiteral(resourceName: "select_photo_empty")
        uiimage.contentMode = .scaleAspectFill
        //Forma redondeada de la imagen
        //uiimgNB.layer.cornerRadius = uiimgNB.frame.width / 2
        uiimage.layer.cornerRadius = 25
        uiimage.clipsToBounds = true
        uiimage.translatesAutoresizingMaskIntoConstraints = false
        return uiimage
    }()
    
   
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(uiimgNB)
        uiimgNB.widthAnchor.constraint(equalToConstant: 50).isActive=true
        uiimgNB.heightAnchor.constraint(equalToConstant: 50).isActive=true
        uiimgNB.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive=true
        uiimgNB.centerYAnchor.constraint(equalTo: centerYAnchor).isActive=true
        
        
        lblNota.font = UIFont.boldSystemFont(ofSize: 16)
        lblNota.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lblNota)
       
        lblNota.topAnchor.constraint(equalTo: topAnchor ,constant : 8).isActive=true
        lblNota.heightAnchor.constraint(equalToConstant: self.frame.height / 2).isActive=true
        lblNota.leadingAnchor.constraint(equalTo: uiimgNB.trailingAnchor, constant: 10).isActive=true
        lblNota.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        
        lbldate.font = UIFont.boldSystemFont(ofSize: 12)
        lbldate.textColor = UIColor.lightGray
        lbldate.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lbldate)
        lbldate.topAnchor.constraint(equalTo: lblNota.bottomAnchor).isActive=true
        lbldate.heightAnchor.constraint(equalToConstant: self.frame.height / 2).isActive=true
        lbldate.leadingAnchor.constraint(equalTo: uiimgNB.trailingAnchor, constant: 10).isActive=true
        lbldate.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
