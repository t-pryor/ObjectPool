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
    
    
    
    init(items:[T]) {
        data.reserveCapacity(data.count)
        for item in items {
            data.append(item)
        }
    }

    // return the object at the head of the harray
    func getFromPool() -> T? {
        var result:T?
        if (data.count > 0) {
            result = self.data.removeAtIndex(0)
        }
        return result
    }

    // return previously used object to the end of the array
    func returnToPool(item:T) {
        self.data.append(item)
    }
}