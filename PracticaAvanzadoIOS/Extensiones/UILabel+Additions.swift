//
//  UILabel+Additions.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 17/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//

import UIKit

extension UILabel{
    func getCustomLabel() -> UILabel{
        self.textColor = UIColor.black
        self.font = UIFont.boldSystemFont(ofSize: 14)
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
