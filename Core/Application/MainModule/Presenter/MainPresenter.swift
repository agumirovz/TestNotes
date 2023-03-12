//
//  MainPresenter.swift
//  TestTask
//
//  Created by G G on 28.12.2022.
//

import Foundation
import UIKit

protocol MainModuleProtocol {
    func success(screenshots: [UIImage])
    func failure()
}

protocol MainPresenterProtocol {
    func viewDidLoad()
    func noteDetailsRoute(noteIndex: Int?,
                          isNewNote: Bool)
}

class MainPresenter: MainPresenterProtocol {
    var view: any MainModuleProtocol
    var router: RouterProtocol
    
    required init(view: any MainModuleProtocol, router: RouterProtocol) {
        self.view   = view
        self.router = router
    }
    
    func viewDidLoad() {
        var screenshots = [UIImage]()
        for note in Notes.shared.notes {
            guard let image = UIImage(data: note.screenshot) else { return }
            screenshots.append(image)
        }
        view.success(screenshots: screenshots)
    }
    
    func noteDetailsRoute(noteIndex: Int?, isNewNote: Bool) {
        router.noteDetailsRoute(noteIndex: noteIndex, isNewNote: isNewNote)
    }
}
