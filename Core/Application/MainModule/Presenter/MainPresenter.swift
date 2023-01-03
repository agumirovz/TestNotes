//
//  MainPresenter.swift
//  TestTask
//
//  Created by G G on 28.12.2022.
//

import Foundation
import UIKit

protocol MainModuleProtocol {
    func success(noteData: [NSAttributedString])
    func failure()
}

protocol MainPresenterProtocol {
    func viewDidLoad()
}

class MainPresenter: MainPresenterProtocol {
    var view: any MainModuleProtocol
    var router: RouterProtocol
    
    required init(view: any MainModuleProtocol, router: RouterProtocol) {
        self.view   = view
        self.router = router
    }
    
    func viewDidLoad() {
        var noteData = [NSAttributedString]()
        for note in Notes.shared.notes {
            noteData.append(try! NSAttributedString(data: note, documentAttributes: nil))
        }
        view.success(noteData: noteData)
        
    }
}
