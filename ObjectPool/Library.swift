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
    
    
    private var books: [Book]
    private let pool: Pool<Book>
    
    // private controls the creation of the singleton completely
    private init(stockLevel: Int) {
        books = [Book]()
        for count in 1...stockLevel {
            books.append(Book(author: "Dickens, Charles", title: "Hard Times", stock: count))
        }
    
        pool = Pool<Book>(items: books)
    }
    

    /* Swift 1.0 Singleton
    private class var singleton: Library {
        struct SingletonWrapper {
            static let singleton = Library(stockLevel:2)
        }
        return SingletonWrapper.singleton
    }*/
    
    
    /*
        Type methods checkout and returnBook interact with the pool on behalf of callers
    
    */
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
        for book in singleton.books {
            println("...Book#\(book.stockNumber)...")
            println("Checked out \(book.checkoutCount) times")
            if (book.reader != nil) {
                println("Checked out to \(book.reader!)")
                
            } else {
                println("In stock")
            }
        }
    }
    
}
