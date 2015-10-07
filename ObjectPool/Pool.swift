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
    
    init(items:[T]) {
        data.reserveCapacity(data.count)
        for item in items {
            data.append(item)
        }
        
        semaphore = dispatch_semaphore_create(items.count)
        
    }

    // return the object at the head of the array
    func getFromPool() -> T? {
        var result:T?
        // when counter reaches zero, calls to the dispatch_semaphore_wait will block
        if (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) == 0) {
            dispatch_sync(arrayQ) {
                result = self.data.removeAtIndex(0)
            }
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
}