//
//  BookSources.swift
//  ObjectPool
//
//  Created by Tim Pryor on 2015-11-04.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

import Foundation

class BookSeller {
    class func buyBook(author:String, title:String, stockNumber:Int) -> Book {
        return Book(author: author, title: title, stock: stockNumber)
    }
}
