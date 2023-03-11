//
//  NoteModel.swift
//  TestTask
//
//  Created by G G on 29.12.2022.
//

import Foundation
import UIKit

class Notes {
    let defaults        = UserDefaults.standard
    static var shared   = Notes()
    
    var notes: [Data] {
        get {
            
            if let data = defaults.value(forKey: "notes") as? Data {
                return try! PropertyListDecoder().decode([Data].self, from: data)
            } else {
                return [Data]()
            }
        }
        
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: "notes")
            }
        }
    }
    
    
    
   
    
}
