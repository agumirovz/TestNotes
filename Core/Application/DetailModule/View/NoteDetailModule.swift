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

class NoteDetailModule: UIViewController,
                        DetailsModuleProtocol,
                        UITextViewDelegate {
    
    var presenter:    DetailsPresenterProtocol!
    var isNewNote:    Bool!
    var attString:    NSAttributedString!
    var noteIndex:    Int!
    var fontSize      = 14
    var textStyleService: TextStyleService!
    
    let textView: UITextView = {
        let text = UITextView()
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        presenter.viewDidLoad()
        setupViews()
        textStyleService = TextStyleService()
    }
    
    func setupViews() {
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImageToNote))
        let delete = isNewNote ? UIBarButtonItem() : UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let bold = UIBarButtonItem(image: UIImage(systemName: "bold"), style: .plain, target: self, action: #selector(changeFont))
        bold.title = Fonts.bold
        let italic = UIBarButtonItem(image: UIImage(systemName: "italic"), style: .plain, target: self, action: #selector(changeFont))
        italic.title = Fonts.italic
        let underlined = UIBarButtonItem(image: UIImage(systemName: "underline"), style: .plain, target: self, action: #selector(changeFont))
        underlined.title = Fonts.underlined
        
        
        
        navigationItem.rightBarButtonItems = [done, add, delete, bold, italic, underlined]
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    @objc func changeFont(sender: UIBarButtonItem) {
        let range = textView.selectedRange
        let string = NSMutableAttributedString(attributedString: textView.attributedText)
        let fontName = textView.font?.fontName
        
        textStyleService.textFontChange(to: sender.title!,
                                        range: range,
                                        string: string,
                                        fontName: fontName ?? "",
                                        fontSize: fontSize) { string, range in
            
            self.textView.attributedText = string
            self.textView.selectedRange = range
            
        }
    }
    
    @objc func doneAction() {
        isNewNote ? presenter.saveNote(attributedString: self.textView.attributedText) :
        presenter.editNote(attributedString: self.textView.attributedText, noteIndex: noteIndex)
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
}


extension NoteDetailModule: PHPickerViewControllerDelegate {
    
    //puts image in note
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self,
                                           completionHandler: { (object, error) in
                
                if let image = object as? UIImage {
                    DispatchQueue.global().async { [self] in
                        let textAttachment = NSTextAttachment()
                        let attString = NSMutableAttributedString(attachment: textAttachment)
                        
                        DispatchQueue.main.async {
                            
                            textAttachment.image = self.resizeImage(width: self.textView.frame.size.width, image: image)
                            self.textView.textStorage.append(attString)
                            picker.dismiss(animated: true, completion: nil)
                            self.textView.selectedRange.location += 1
                            
                        }
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
    
}
