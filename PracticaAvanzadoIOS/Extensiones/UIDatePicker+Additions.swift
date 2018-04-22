//
//  UIDatePicker+Additions.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 18/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//

import UIKit

extension UIDatePicker {
    func getCustomDatePicker() -> UIDatePicker{
        self.backgroundColor = UIColor.darkBlue
        self.datePickerMode = .date
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFit
        self.subviews[0].backgroundColor = UIColor.darkBlue
        self.setValue(UIColor.white, forKeyPath: "textColor")
        self.locale = Locale(identifier: "ES")
        
        return self
    }
}


