//
//  UIViewController+Additions.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 2/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//

import UIKit
import MapKit




extension UIViewController{
    func wrappedInNavigation()->UINavigationController{
        return CustomNavController( rootViewController: self)
    }
    func setupPlusButtonForNavBar(selector : Selector){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: selector)
        
    }
    func setupCancelButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func setupBackBlueView(height : CGFloat)-> UIView{
        let backView=UIView()
        backView.backgroundColor = UIColor.darkBlue
        backView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backView)
        backView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        backView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive=true
        return backView
    }
    
}

//Indicadores de pila, señal etc en blanco
class CustomNavController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
