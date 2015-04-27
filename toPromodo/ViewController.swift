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
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        cell.delegate = self
        cell.toDoItem = item
        return cell
    }
    
    
    
    
    // MARK: - UIScrollViewDelegate methods
    // contains scrollViewDidScroll, and other methods, to keep track of dragging the scrollView
 
    // a cell that is rendered as a placeholder to indicate where a new item is added
    let placeHolderCell = TableViewCell(style: .Default, reuseIdentifier: "cell")
    
    // indicates the state of this behavior
    var pullDownInProgress = false

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        // this behavior starts when a user pulls down while at the top of the table
        pullDownInProgress = scrollView.contentOffset.y <= 0.0
        placeHolderCell.backgroundColor = UIColor.redColor()
        if pullDownInProgress {
            // add the placeholder
            tableView.insertSubview(placeHolderCell, atIndex: 0)
        }
    }
    //reposition the placeholder by setting its frame in scrollViewDidScroll method
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var scrollViewContentOffsetY = scrollView.contentOffset.y
        if pullDownInProgress && scrollView.contentOffset.y <= 0.0 {
            // maintain the location of the placeholder
            placeHolderCell.frame = CGRect(x: 0, y: -tableView.rowHeight,
                width: tableView.frame.size.width, height: tableView.rowHeight)
            placeHolderCell.label.text = -scrollViewContentOffsetY > tableView.rowHeight ?
                "Release to add item" : "Pull to add item"
            placeHolderCell.alpha = min(1.0, -scrollViewContentOffsetY / tableView.rowHeight)
        } else {
            pullDownInProgress = false
        }
    }

    // end of scrolling down, check if this pull is far enough to create a new item
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // check whether the user pulled down far enough
        if pullDownInProgress && -scrollView.contentOffset.y > tableView.rowHeight {
            toDoItemAdded()
        }
        pullDownInProgress = false
        placeHolderCell.removeFromSuperview()
    }
    
    
    
    // MARK: - TableView Cell Delegate methods
    // contains add, delete, edit methods
    
    func toDoItemDeleted(toDoItem: ToDoItem) {
        let index = (toDoItems as NSArray).indexOfObject(toDoItem)
        if index == NSNotFound { return }
        
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        toDoItems.removeAtIndex(index)
        
        // loop over the visible cells to animate delete
        let visibleCells = tableView.visibleCells() as! [TableViewCell]
        let lastView = visibleCells[visibleCells.count - 1] as TableViewCell
        var delay = 0.0
        var startAnimating = false
        for i in 0..<visibleCells.count {
            let cell = visibleCells[i]
            if startAnimating {
                UIView.animateWithDuration(0.3, delay: delay, options: .CurveEaseInOut,
                    animations: {() in
                        cell.frame = CGRectOffset(cell.frame, 0.0,
                            -cell.frame.size.height)},
                    completion: {(finished: Bool) in
                        if (cell == lastView) {
                            self.tableView.reloadData()
                        }
                    }
                )
                delay += 0.03
            }
            if cell.toDoItem === toDoItem {
                startAnimating = true
                cell.hidden = true
            }
        }
        
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableView.endUpdates()
    }

    
    func toDoItemAdded() {
        let toDoItem = ToDoItem(text: "")
        toDoItems.insert(toDoItem, atIndex: 0)
        tableView.reloadData()
        // enter edit mode
        var editCell: TableViewCell
        let visibleCells = tableView.visibleCells() as! [TableViewCell]
        for cell in visibleCells {
            if (cell.toDoItem === toDoItem) {
                editCell = cell
                editCell.label.becomeFirstResponder()
                break
            }
        }
    }
    
    
    func cellDidBeginEditing(editingCell: TableViewCell) {
        var editingOffset = tableView.contentOffset.y - editingCell.frame.origin.y as CGFloat
        let visibleCells = tableView.visibleCells() as! [TableViewCell]
        for cell in visibleCells {
            UIView.animateWithDuration(0.3, animations: {() in
                cell.transform = CGAffineTransformMakeTranslation(0, editingOffset)
                if cell !== editingCell {
                    cell.alpha = 0.3
                }
            })
        }
    }
    
    func cellDidEndEditing(editingCell: TableViewCell) {
        let visibleCells = tableView.visibleCells() as! [TableViewCell]
        for cell: TableViewCell in visibleCells {
            UIView.animateWithDuration(0.3, animations: {() in
                cell.transform = CGAffineTransformIdentity
                if cell !== editingCell {
                    cell.alpha = 1.0
                }
            })
        }
    }
}

