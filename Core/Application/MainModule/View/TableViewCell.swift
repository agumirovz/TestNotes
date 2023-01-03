//
//  TableViewCell.swift
//  TestTask
//
//  Created by G G on 28.12.2022.
//

import Foundation
import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell{
    static let cellId = "CollectionViewCell"
    
    let notePreview: UITextView           = {
        let textView                      = UITextView()
        textView.clipsToBounds            = true
        textView.backgroundColor          = .lightGray
        textView.isSelectable             = false
        textView.isEditable               = false
        textView.isScrollEnabled          = false
        textView.isUserInteractionEnabled = false
        textView.delaysContentTouches     = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor     = UIColor.gray
        clipsToBounds       = true
        layer.cornerRadius  = 20
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(notePreview)
        
        notePreview.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}
