////
////  NoteDetails.swift
////  TestTask
////
////  Created by G G on 28.12.2022.
////
//

import UIKit
import Photos
import PhotosUI

extension NoteDetailModule {
    func success(attString: NSAttributedString) {
        self.textView.attributedText = attString
    }
    
    func failure() {
        print("Error")
    }
}

class NoteDetailModule: UIViewController, DetailsModuleProtocol,
                        UITextViewDelegate, PHPickerViewControllerDelegate {
    
    var router:       RouterProtocol!
    var presenter:    DetailsPresenterProtocol!
    var isNewNote:    Bool!
    var attString:    NSAttributedString!
    var noteIndex:    Int!
    var fontSize      = 14
    var isUnderlined: Bool = false
    var isItalic:     Bool = false
    var isBold:       Bool = false
   
    let textView: UITextView = {
        let text = UITextView()
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        presenter.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveOrEditNote)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImageToNote)),
            isNewNote ? UIBarButtonItem() : UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote)),
            UIBarButtonItem(image: UIImage(systemName: "bold"), style: .plain, target: self, action: #selector(makeTextBold)),
            UIBarButtonItem(image: UIImage(systemName: "italic"), style: .plain, target: self, action: #selector(makeTextItalic)),
            UIBarButtonItem(image: UIImage(systemName: "underline"), style: .plain, target: self, action: #selector(makeTextUnderlined))
        ]
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    @objc func makeTextBold() {
        isBold.toggle()
        isBold ? textFontChange(font: Fonts.bold) : textFontChange(font: Fonts.regular)
    }
    
    @objc func makeTextItalic() {
        isItalic.toggle()
        isItalic ? textFontChange(font: Fonts.italic) : textFontChange(font: Fonts.regular)
    }
    
    @objc func makeTextUnderlined() {
        isUnderlined.toggle()
        textFontChange(font: Fonts.underlined)
    }
    
    @objc func saveOrEditNote() {
        presenter.saveOrEditNote(attributedString: self.textView.attributedText, noteIndex: noteIndex, isNewNote: isNewNote)
    }
    
    @objc func deleteNote() {
        presenter.deleteNote(noteIndex: noteIndex)
    }
    // opens image picker
    @objc func addImageToNote() {
        var config      = PHPickerConfiguration()
        config.filter   = .images
        let picker      = PHPickerViewController(configuration: config)
        picker.delegate = self
        config.selectionLimit = 1
        self.present(picker, animated: true)
    }
    //puts image in note
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async { [self] in
                        let textAttachment      = NSTextAttachment()
                        textAttachment.image    = resizeImage(width: textView.frame.size.width, image: image)
                        let attString           = NSMutableAttributedString(attachment: textAttachment)
                        textView.textStorage.append(attString)
                        picker.dismiss(animated: true, completion: nil)
                        textView.selectedRange.location += 1
                    }
                }
            })
        }
    }
    //resizes images with original ratio based on image width
    private func resizeImage(width: Double, image: UIImage) -> UIImage {
        let scaleFactor     = image.size.height/image.size.width
        let newSize         = CGSize(width: width, height: width * scaleFactor)
        let rect            = CGRect(x: 0, y: 0, width: width, height: width * scaleFactor)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        guard let newImage  = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return newImage
    }
    // Main function to change textView text's font
    func textFontChange(font: String) {
        let range = textView.selectedRange
        let string = NSMutableAttributedString(attributedString: textView.attributedText)
        switch font {
        case Fonts.bold:
            let bold = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(fontSize + 2))]
            string.addAttributes(bold, range: range)
        case Fonts.italic:
            let italic = [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: CGFloat(fontSize))]
            string.addAttributes(italic, range: range)
        case Fonts.regular:
            let defaultFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(fontSize))]
            string.addAttributes(defaultFont, range: range)
        default: break
        }
        
        if isUnderlined {
            let underline = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
            string.addAttributes(underline, range: range)
        } else {
            let defaultFont = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.RawValue()]
            string.addAttributes(defaultFont, range: range)
        }
        
        textView.attributedText = string
        textView.selectedRange = range
    }
}

enum Fonts {
    static var bold       = "bold"
    static var italic     = "italic"
    static var underlined = "underlined"
    static var regular    = "regular"
}
