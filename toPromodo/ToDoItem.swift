//
//  ToDoItem.swift
//  toPromodo
//
//  Created by Julie Zhou on 4/23/15.
//  Copyright (c) 2015 Julie Zhou. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {
    var text: String
    var completed: Bool
    
    init(text: String) {
        self.text = text
        self.completed = false
    }
   
}
