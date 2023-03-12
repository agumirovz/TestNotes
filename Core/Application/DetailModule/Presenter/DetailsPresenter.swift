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
    
    func viewDidLoad()
    func saveNote(attributedString: NSAttributedString,
                  screenshot: Data)
    func editNote(attributedString: NSAttributedString,
                  noteIndex: Int,
                  screenshot: Data)
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
            let attString = try! NSAttributedString(data: Notes.shared.notes[noteIndex].attString, documentAttributes: nil)
            view.success(attString: attString)
        }
    }
        
    
    func saveNote(attributedString: NSAttributedString, screenshot: Data) {
        let data = try! attributedString.data(from: NSRange(location: 0,
                                                            length: attributedString.length),
                                              documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd])
        Notes.shared.notes.insert(NoteModel(attString: data,
                                            screenshot: screenshot), at: 0)
        router.goBack()
    }
    
    func editNote(attributedString: NSAttributedString,
                  noteIndex: Int,
                  screenshot: Data) {
        
        let data = try! attributedString.data(from: NSRange(location: 0,
                                                            length: attributedString.length),
                                              documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd])
        
        Notes.shared.notes[noteIndex] = NoteModel(attString: data,
                                                  screenshot: screenshot)
        router.goBack()
    }
    
    func deleteNote(noteIndex: Int) {
        Notes.shared.notes.remove(at: noteIndex)
        router.goBack()
    }
}
