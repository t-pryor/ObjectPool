//
//  Book.swift
//  ObjectPool
//
//  Created by Tim Pryor on 2015-10-04.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//


/*
need a pattern that manages a number of identical, interchangeable objects
and provides the model by which they can be fairly and equitably used
abstract examples in SW dev: threads and network connections

*/

class Book {
    let author: String
    let title: String
    let stockNumber: Int
    var reader: String?
    var checkoutCount = 0
    
    init(author: String, title: String, stock: Int) {
        self.author = author
        self.title = title
        self.stockNumber = stock
        
    }
}