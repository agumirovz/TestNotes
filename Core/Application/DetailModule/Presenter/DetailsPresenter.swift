//
//  DetailsPresenter.swift
//  TestTask
//
//  Created by G G on 28.12.2022.
//

import Foundation

protocol DetailsModuleProtocol {
    func success(attString: NSAttributedString)
    func failure()
    
}

protocol DetailsPresenterProtocol {
    init(view: DetailsModuleProtocol,
         router: RouterProtocol, noteIndex: Int, isNewNote: Bool)
    func viewDidLoad()
    func saveOrEditNote(attributedString: NSAttributedString, noteIndex: Int?, isNewNote: Bool)
    func deleteNote(noteIndex: Int)
}

class DetailsPresenter: DetailsPresenterProtocol {
    var view:       any DetailsModuleProtocol
    var router:     RouterProtocol
    var noteIndex:  Int
    var isNewNote:  Bool
    
    required init(view: DetailsModuleProtocol, router: RouterProtocol, noteIndex: Int, isNewNote:  Bool) {
        self.view       = view
        self.router     = router
        self.noteIndex  = noteIndex
        self.isNewNote  = isNewNote
    }
    
    func viewDidLoad() {
        if isNewNote {
            view.success(attString: NSAttributedString())
        } else {
            let attString = try! NSAttributedString(data: Notes.shared.notes[noteIndex], documentAttributes: nil)
            view.success(attString: attString)
        }
    }
        
    func saveOrEditNote(attributedString: NSAttributedString, noteIndex: Int?, isNewNote: Bool) {
         let data = try! attributedString.data(from: NSRange(location: 0, length: attributedString.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd])
         if isNewNote {
             Notes.shared.notes.insert(data, at: 0)
         } else {
             Notes.shared.notes[noteIndex!] = data
         }
        router.goBack()
     }
    
    func deleteNote(noteIndex: Int) {
        Notes.shared.notes.remove(at: noteIndex)
        router.goBack()
    }
}
