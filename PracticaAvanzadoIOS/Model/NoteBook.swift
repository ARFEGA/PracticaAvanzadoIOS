//
//  NoteBook.swift
//  PracticaAvanzadoIOS
//
//  Created by ARMANDO on 6/4/18.
//  Copyright © 2018 ARMANDO. All rights reserved.
//



import Foundation

struct ExpandableNames
{
    var isExpandable : Bool
    var names : [Contact]
}

struct Contact{
    let name : String
    var isFavorite : Bool = false
}

