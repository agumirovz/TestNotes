//
//  textStyleService.swift
//  TestNotes
//
//  Created by G G on 11.03.2023.
//

import Foundation
import UIKit


extension UITextView {
    
    func screenShot() -> Data {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.bounds.width,
                                                      height: self.bounds.height),
                                               false, 1)
        
        isEditable = false
        backgroundColor = UIColor(red: 180/255, green: 194/255, blue: 211/255, alpha: 0.3)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        guard let data = screenshot.jpegData(compressionQuality: 0.5) else { return Data() }
        backgroundColor = .systemBackground
        return data
    }
    
    func textFontChange(to: Fonts) {
        let range = selectedRange
        let underlined = textStorage.attribute(.underlineStyle, at: range.location, effectiveRange: nil) as? Int
        
        if let initialFont = textStorage.attribute(.font, at: range.location, effectiveRange: nil) as? UIFont {
            
            var currentTraits = initialFont.fontDescriptor.symbolicTraits
            let fontSize = initialFont.pointSize
            
            
            if to == .bold {
                currentTraits.contains(.traitBold) ?
                currentTraits.remove(.traitBold) :
                currentTraits.update(with: .traitBold)
                
                guard let descriptor = initialFont.fontDescriptor.withSymbolicTraits(currentTraits) else { return }
                
                let updateFont = UIFont(descriptor: descriptor,
                                        size: fontSize)
                
                textStorage.enumerateAttribute(.font, in: range) { (_, range, stop) in
                    textStorage.beginEditing()
                    textStorage.addAttribute(.font, value: updateFont, range: range)
                    textStorage.endEditing()
                }
            }
            
            if to == .italic {
                currentTraits.contains(.traitItalic) ?
                currentTraits.remove(.traitItalic) :
                currentTraits.update(with: .traitItalic)
                
                guard let descriptor = initialFont.fontDescriptor.withSymbolicTraits(currentTraits) else { return }
                
                let updateFont = UIFont(descriptor: descriptor,
                                        size: fontSize)
                
                textStorage.enumerateAttribute(.font, in: range) { (_, range, stop) in
                    textStorage.beginEditing()
                    textStorage.addAttribute(.font, value: updateFont, range: range)
                    textStorage.endEditing()
                }
            }
            
            if to == .underlined {
                underlined == NSUnderlineStyle.single.rawValue ?
                textStorage.enumerateAttribute(.underlineStyle, in: range,
                                                        options: .longestEffectiveRangeNotRequired,
                                                        using: { (_, range, stop) in
                    textStorage.beginEditing()
                    textStorage.removeAttribute(NSAttributedString.Key.underlineStyle, range: range)
                    textStorage.endEditing()
                }) :
                textStorage.enumerateAttribute(.underlineStyle, in: range,
                                                        options: .longestEffectiveRangeNotRequired,
                                                        using: { (_, range, stop) in
                    textStorage.beginEditing()
                    textStorage.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                    textStorage.endEditing()
                })
            }
            
            
        }
    }
    
}

enum Fonts: Int {
    case bold
    case italic
    case underlined
    case regular
}
