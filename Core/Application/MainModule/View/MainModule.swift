//
//  MainModule.swift
//  TestTask
//
//  Created by G G on 28.12.2022.
//

import Foundation
import UIKit
import SnapKit

extension MainModule {
    func success(screenshots: [UIImage]) {
        self.screenshots = screenshots
        self.mainCollectionView.reloadData()
    }
    
    func failure() {
        print("Error")
    }
}

class MainModule: UIViewController, MainModuleProtocol {
    var presenter:  MainPresenterProtocol!
    var cellWidth   = 150
    var screenshots    = [UIImage]()
    
    var mainCollectionView: UICollectionView = {
        let layout                 = UICollectionViewFlowLayout()
        let collection             = UICollectionView(frame: .zero,
                                                      collectionViewLayout: layout)
        collection.backgroundColor = UIColor.clear
        collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cellId)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        cellWidth = Int(view.frame.size.width * 0.45)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self, action: #selector(addNewNote))
        presenter.viewDidLoad()
        mainCollectionSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewDidLoad()
        mainCollectionView.reloadData()
    }
    
    @objc func addNewNote() {
        presenter.noteDetailsRoute(noteIndex: nil, isNewNote: true)
    }
}


extension MainModule: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func mainCollectionSetup() {
        mainCollectionView.delegate                       = self
        mainCollectionView.dataSource                     = self
        mainCollectionView.showsVerticalScrollIndicator   = false
        mainCollectionView.showsHorizontalScrollIndicator = false
        mainCollectionView.contentInset                   = UIEdgeInsets(top: 10, left: 10,
                                                                         bottom: 0, right: 10)
        
        view.addSubview(mainCollectionView)
        mainCollectionView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellId, for: indexPath) as? CollectionViewCell
        else { return UICollectionViewCell() }
        cell.notePreview.image = screenshots[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.noteDetailsRoute(noteIndex: indexPath.row,
                                          isNewNote: false)
    }
}
