//
//  main.swift
//  ObjectPool
//
//  Created by Tim Pryor on 2015-10-04.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

import Foundation

var queue = dispatch_queue_create("workQ", DISPATCH_QUEUE_CONCURRENT)
var group = dispatch_group_create()

println("Starting")



// each block is is submitted to a concurrent queue
// NSThread.sleepForTimeInterval used so that books will not be returned in order they were taken out
// if you run without this, each book is checked out and returned 20 times if for loop is 1...100 and pool has 5 copies of book
// they would be returned in strict rotation, which isn't how pool objects are used



for i in 1...100 {
    dispatch_group_async(group, queue) {
        var book = Library.checkoutBook("reader#\(i)")
        if (book != nil) {
            NSThread.sleepForTimeInterval(Double(rand() % 3));
            Library.returnBook(book!)
        }
    }
}

dispatch_group_wait(group, DISPATCH_TIME_FOREVER)

println("All blocks complete")

Library.printReport()