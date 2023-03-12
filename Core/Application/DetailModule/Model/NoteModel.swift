//
//  NoteModel.swift
//  TestTask
//
//  Created by G G on 29.12.2022.
//

import Foundation
import UIKit

class Notes {
    let defaults = UserDefaults.standard
    static var shared = Notes()
    
    var notes: [NoteModel] {
        
        get {
            if let data = defaults.value(forKey: "notes") as? Data {
                return try! PropertyListDecoder().decode([NoteModel].self, from: data)
            } else {
                return []
            }
        }
        
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: "notes")
            }
        }
    }
}

struct NoteModel: Codable {
    let attString: Data
    let screenshot: Data
    
}
