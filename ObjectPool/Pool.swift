//
//  Pool.swift
//  ObjectPool
//
//  Created by Tim Pryor on 2015-10-04.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

/*
    Generic Pool class manages a collection of objects of a given type

*/

import Foundation

class Pool<T> {
    // data array is used like a simple queue collection containing the 
    // objects that are available for use
    private var data = [T]()
    // arrayQ is a serial queue so that only one block is executed at a time
    // only one thread can modify the data array
    private let arrayQ = dispatch_queue_create("arrayQ", DISPATCH_QUEUE_SERIAL)
    
    // the counter is decremented each time the dispatch_semaphore_wait func is called
    private let semaphore: dispatch_semaphore_t
    
    private var itemCount = 0
    private let maxItemCount: Int
    private let itemFactory: () -> T
    
    
    
    // Pool initializer receives a closure that can be used to create new items for the pool
    // Int parameter specifies the maximum number of times that the closure may be used
    init(maxItemCount: Int, factory: () -> T) {
        self.itemFactory = factory
        self.maxItemCount = maxItemCount
        semaphore = dispatch_semaphore_create(maxItemCount)
    }
    

    // return the object at the head of the array
    func getFromPool() -> T? {
        var result:T?
        // when counter reaches zero, calls to the dispatch_semaphore_wait will block
        if (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) == 0) {
            dispatch_sync(arrayQ) {
                // check for the state of the pool
                if (self.data.count == 0 && self.itemCount < self.maxItemCount) {
                    result = self.itemFactory()
                    self.itemCount++
                } else {
                    result = self.data.removeAtIndex(0)
                }
            }
        // to reach this point in the method, thread has passed through the semaphore
        // so there is either an object waiting for use in the data array or we need to call the factory closure to create one
        // allows us to defer the creation of the items in the pool until there is a demand for them
        }
        
        return result
    }

    // return previously used object to the end of the array
    func returnToPool(item:T) {
        dispatch_async(arrayQ) {
            self.data.append(item)
            // counter is incremented
            dispatch_semaphore_signal(self.semaphore)
        }
    }
    
    
    // Pool class creates the objects
    // the Library class has no reference to them at all
    // accepts a callback closure that is passed the data array within a synchronous GCD barrier block
    
    func processPoolItems(callback: [T] -> Void) {
        dispatch_barrier_sync(arrayQ) {
            callback(self.data)
        }
    }
}