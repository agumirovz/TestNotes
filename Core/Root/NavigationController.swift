//
//  NavigationController.swift
//  TestTask
//
//  Created by G G on 28.12.2022.
//

import Foundation
import UIKit

class Navigation: UINavigationController {
    var mainModule       = MainModule()
    var noteDetailModule = NoteDetailModule()
    
    override func viewDidLoad() {
        configureUI()
    }
    
    func configureUI() {
        navigationBar.backgroundColor = UIColor.systemBackground
        
        mainModule.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addTapped)),
            UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addTapped)),
            UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addTapped))]
    }
    
    @objc func addTapped() {
        print("sdassa")
    }
}
