//
//  NoteBook+Notifications.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 16/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//

import UIKit

extension NoteBookVC{
    
    //Alta en notificaciones
    
    func altaNotificaciones(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: Notification.Name(rawValue: NOTE_SAVED), object: nil, queue: OperationQueue.main) { (notification) in
            // userInfo is the payload send by sender of notification
            if let userInfo = notification.userInfo {
                // Safely unwrap the name sent out by the notification sender
                //self.notes.append(userInfo[NOTE_KEY] as! Note)
                let note : Note = userInfo[NOTE_KEY] as! Note
                var array = [Int]() ;
                for (row,NB) in self.NoteBookS.enumerated(){
                    if note.myNotebook == NB{
                        array.append(row)
                        let indexSet = IndexSet(array)
                        self.tableView.reloadSections(indexSet, with: .fade)
                    }
                }
            }
        }
    }
}
