//
//  textStyleService.swift
//  TestNotes
//
//  Created by G G on 11.03.2023.
//

import Foundation
import UIKit

class TextStyleService {
    
    func textFontChange(to: Fonts,
                        textView: UITextView) {
        let range = textView.selectedRange
        let underlined = textView.textStorage.attribute(.underlineStyle, at: range.location, effectiveRange: nil) as? Int
        
        if let initialFont = textView.textStorage.attribute(.font, at: range.location, effectiveRange: nil) as? UIFont {
            
            var currentTraits = initialFont.fontDescriptor.symbolicTraits
            let fontSize = initialFont.pointSize
            
            switch to {
            case .bold:
                currentTraits.contains(.traitBold) ?
                currentTraits.remove(.traitBold) :
                currentTraits.update(with: .traitBold)
            case .italic:
                currentTraits.contains(.traitItalic) ? currentTraits.remove(.traitItalic) :
                currentTraits.update(with: .traitItalic)
            case .underlined:
                underlined == NSUnderlineStyle.single.rawValue ?
                textView.textStorage.enumerateAttribute(.underlineStyle, in: range,
                                                        options: .longestEffectiveRangeNotRequired,
                                                        using: { (_, range, stop) in
                    textView.textStorage.beginEditing()
                    textView.textStorage.removeAttribute(NSAttributedString.Key.underlineStyle, range: range)
                    textView.textStorage.endEditing()
                }) :
                textView.textStorage.enumerateAttribute(.underlineStyle, in: range,
                                                        options: .longestEffectiveRangeNotRequired,
                                                        using: { (_, range, stop) in
                    textView.textStorage.beginEditing()
                    textView.textStorage.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                    textView.textStorage.endEditing()
                })
            default:
                break
            }
            
            guard let descriptor = initialFont.fontDescriptor.withSymbolicTraits(currentTraits) else { return }
            
            let updateFont = UIFont(descriptor: descriptor,
                                    size: fontSize)
            
            textView.textStorage.enumerateAttribute(.font, in: range) { (_, range, stop) in
                textView.textStorage.beginEditing()
                textView.textStorage.addAttribute(.font, value: updateFont, range: range)
                textView.textStorage.endEditing()
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
