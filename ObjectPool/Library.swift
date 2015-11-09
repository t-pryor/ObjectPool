//
//  Library.swift
//  ObjectPool
//
//  Created by Tim Pryor on 2015-10-06.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

import Foundation

/* 
    The Library class implements the object pool pattern by combining the Pool class with the singleton pattern.
    Singleton used because there should only be one Library, although the Library itself could have multiple pools,
    each of which manages copies of a single title.



*/


final class Library {
    
    // Swift 1.2 Singleton
    static let singleton = Library(stockLevel: 5)
    
    private let pool: Pool<Book>
    
    // private controls the creation of the singleton completely
    private init(stockLevel: Int) {
        
        var stockId = 1
        
        pool = Pool<Book>(maxItemCount: stockLevel, factory: { () in
            return BookSeller.buyBook("Dickens, Charles", title: "Hard Times", stockNumber: stockId++)
        })
    }

    class func checkoutBook(reader: String) -> Book? {
        var book = singleton.pool.getFromPool()
        book?.reader = reader
        book?.checkoutCount++
        objc_sync_enter(self)
        println("\n--- BOOK CHECKOUT ---")
        println(book?.reader)
        objc_sync_exit(self)
        return book
    }
    
    class func returnBook(book: Book) {
        
        objc_sync_enter(self)
        println("\n--- RETURN BOOK ---")
        println(book.reader)
        objc_sync_exit(self)
        book.reader = nil
        singleton.pool.returnToPool(book)
    }
    
    // details each of the Book objects that the Library created
    class func printReport() {
        singleton.pool.processPoolItems({(books) in
            for book in books {
                println("...Book#\(book.stockNumber)...")
                println("Checked out \(book.checkoutCount) times")
                if (book.reader != nil) {
                    println("Checked out to \(book.reader!)")
                    
                } else {
                    println("In stock")
                }
            }
            println("There are \(books.count) books in the pool")
        })
    }
    
}
