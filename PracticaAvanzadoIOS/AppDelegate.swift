//
//  AppDelegate.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 2/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//

import UIKit



//Asegurar que la pila y demás indicadores de la parte superior están en blanco
extension UINavigationController{
    open override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UISplitViewControllerDelegate {

    var window: UIWindow?
    var SplitVC : UISplitViewController!
    var NoteBook_VC : NoteBookVC!
    var Note_VC : NoteVC!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
            //Apariencia del navigationBar de toda la app
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().tintColor  = .white
            UINavigationBar.appearance().barTintColor = UIColor.darkBlue
            UINavigationBar.appearance().prefersLargeTitles = true
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        
        
        window = UIWindow()
        window?.makeKeyAndVisible()
       
        NoteBook_VC = NoteBookVC()
        Note_VC = NoteVC()
        //MARK: - DELEGATES ASIGNED
        let terminal = UIDevice()
        print(terminal.modelName)
        
        //El segundo valor del array "terminal.modelName[1]" indica si el modelo acepta splitview
        if (UIDevice.current.userInterfaceIdiom == .pad) || (terminal.modelName[1] as! Bool && (UIApplication.shared.statusBarOrientation == .landscapeLeft ||
            UIApplication.shared.statusBarOrientation == .landscapeRight))  {
            NoteBook_VC.delegate = Note_VC
        } else {
            NoteBook_VC.delegate = NoteBook_VC
        }
        SplitVC = UISplitViewController()
        SplitVC.delegate = self
        SplitVC?.viewControllers=[NoteBook_VC.wrappedInNavigation(),Note_VC.wrappedInNavigation()]
       //Este boton aparece en modo landscape para ocultar master view del split
        Note_VC.navigationItem.leftBarButtonItem =  SplitVC.displayModeButtonItem
        window?.rootViewController = SplitVC
        return true
    }

    func primaryViewController(forExpanding splitViewController: UISplitViewController) -> UIViewController?
    {
        NoteBook_VC.delegate = Note_VC
        return SplitVC.viewControllers.first
    }
    func primaryViewController(forCollapsing splitViewController: UISplitViewController) -> UIViewController? {
        //splitVC?.preferredDisplayMode = .primaryHidden
        NoteBook_VC.delegate = NoteBook_VC
        return SplitVC.viewControllers.first
    }
    
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    //    func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
    //        return (splitVC?.displayMode)!
    //    }
    //
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        
        return Note_VC.wrappedInNavigation()
        //let detailNavigation: UINavigationController
//        if type(of: primaryViewController ) == SeasonListViewController.self {
//            return seasonDetailNavigation
//        } else {
//            return houseDetailNavigation
//        }
    }
    //
}

