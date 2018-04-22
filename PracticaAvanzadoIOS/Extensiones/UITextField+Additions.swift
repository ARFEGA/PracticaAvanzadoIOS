//
//  UITextField+Additions.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 17/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//

import UIKit

extension UITextField{
    func getCustomTextField() -> UITextField{
        //self.backgroundColor = UIColor.backSection
        self.font = UIFont.boldSystemFont(ofSize: 16)
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
