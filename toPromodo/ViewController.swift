//
//  ViewController.swift
//  toPromodo
//
//  Created by Julie Zhou on 4/23/15.
//  Copyright (c) 2015 Julie Zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    var toDoItems = [ToDoItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (toDoItems.count > 0) {
            return
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(TableViewCell.self,forCellReuseIdentifier:"cell")

        toDoItems.append(ToDoItem(text: "feed the cat"))
        toDoItems.append(ToDoItem(text: "buy eggs"))
        toDoItems.append(ToDoItem(text: "watch WWDC videos"))
        toDoItems.append(ToDoItem(text: "buy a new iphone"))
        toDoItems.append(ToDoItem(text: "darn holes in socks"))
        toDoItems.append(ToDoItem(text: "write this tutorial"))
        toDoItems.append(ToDoItem(text: "master Swift"))
        toDoItems.append(ToDoItem(text: "learn to draw"))
        toDoItems.append(ToDoItem(text: "get more exercise"))
        toDoItems.append(ToDoItem(text: "catch up with Mom"))
        toDoItems.append(ToDoItem(text: "get a hair cut"))
        tableView.rowHeight = 50.0
//        tableView.backgroundColor = UIColor.blackColor()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        let item = toDoItems[indexPath.row]
        cell.textLabel?.text = item.text
        cell.selectionStyle = .None
        cell.delegate = self
        cell.toDoItem = item
        return cell
    }
    
    func toDoItemDeleted(todoItem: ToDoItem) {
        let index = (toDoItems as NSArray).indexOfObject(todoItem)
        if index == NSNotFound {return}
        
        toDoItems.removeAtIndex(index)
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableView.endUpdates()
    }
}

