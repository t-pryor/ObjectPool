//
//  PoolItem.swift
//  ObjectPool
//
//  Created by Tim Pryor on 2015-11-09.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

import Foundation

// optional protocol requirements can only be specified if your protocol is marked with the @objc attribute
// can be adopted only by classes that inherit from Objective-C classes or other @objc classes
// They can't be adopted by structures or enumerations

// allows us to downcast objects to the protocol so we can read the canReuse property in the pool class


@objc protocol PoolItem {
    
    var canReuse:Bool {get}
    
}
