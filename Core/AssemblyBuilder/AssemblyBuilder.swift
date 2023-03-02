//
//  AssemblyBuilder.swift
//  TestTask
//
//  Created by G G on 28.12.2022.
//

import Foundation
import UIKit


protocol AssemblyBuilderProtocol {
    func buildMainModule(router: RouterProtocol) -> MainModule
    func buildDetailsModule(router: RouterProtocol,
                            noteIndex: Int,
                            isNewNote: Bool) -> NoteDetailModule
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    
    func buildMainModule(router: RouterProtocol) -> MainModule {
        let view        = MainModule()
        let presenter   = MainPresenter(view: view, router: router)
        view.presenter  = presenter
        return view
    }
    
    func buildDetailsModule(router: RouterProtocol,
                            noteIndex: Int,
                            isNewNote: Bool) -> NoteDetailModule {
        let view        = NoteDetailModule()
        let presenter   = DetailsPresenter(view: view,
                                           router: router,
                                           noteIndex: noteIndex,
                                           isNewNote: isNewNote)
        let isNewNote   = isNewNote
        view.presenter  = presenter
        view.isNewNote  = isNewNote
        view.noteIndex  = noteIndex
        return view
    }
}
