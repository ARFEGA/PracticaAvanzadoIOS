//
//  NoteBook+CustomHeaderInSection.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 13/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//

import UIKit

class CustomHeader: UITableViewHeaderFooterView {
    static let reuseIdentifer = "CustomHeaderReuseIdentifier"
    
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        //let customLabel = UILabel.init()
        //customLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        //customLabel.translatesAutoresizingMaskIntoConstraints = false
        //self.contentView.addSubview(customLabel)
        
        
        //let margins = contentView.layoutMarginsGuide
        //customLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        //customLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        //customLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        //customLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
