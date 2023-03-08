//
//  DIContainer.swift
//  TestNotes
//
//  Created by G G on 08.03.2023.
//

import Foundation

class DIContainer {
    
    enum ContainterErrors: Error {
        case valueNotRegistered
    }
    
    static var standart = DIContainer()
    private var dependencies = [String:Weak]()
    
    private func register<T>(_ dependency: T) {
        let key = "\(type(of: T.self))"
        let weak = Weak(weakValue: dependency as AnyObject)
        dependencies[key] = weak
    }
    
    private func resolve<T>() throws -> T {
        let key = "\(type(of: T.self))"
        let weak = dependencies[key]
        
        if weak != nil {
            return weak?.weakValue as! T
        } else {
            return ContainterErrors.valueNotRegistered as! T
        }
    }
}


class Weak {
    
    weak var weakValue: AnyObject?
    
    init(weakValue: AnyObject) {
        self.weakValue = weakValue
    }
}

