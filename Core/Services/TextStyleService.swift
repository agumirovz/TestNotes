//
//  textStyleService.swift
//  TestNotes
//
//  Created by G G on 11.03.2023.
//

import Foundation
import UIKit

class TextStyleService {
    
    func textFontChange(to: String,
                        range: NSRange,
                        string: NSMutableAttributedString,
                        fontName: String,
                        fontSize: Int,
                        completion: @escaping (_ string: NSMutableAttributedString,
                                               _ range: NSRange) -> Void) {
        
        let bold = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(fontSize))]
        let italic = [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: CGFloat(fontSize))]
        let regular = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(fontSize))]
        let underlined = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        var isUnderlined = false
        string.enumerateAttributes(in: range) { dict, range, value in
            if dict.keys.contains(.underlineStyle) {
                isUnderlined = true
            }
        }
        
        switch to {
        case Fonts.bold:
            fontName == Fonts.bold ? string.addAttributes(regular, range: range) :
            string.addAttributes(bold, range: range)
        case Fonts.italic:
            fontName == Fonts.italic ? string.addAttributes(regular, range: range) :
            string.addAttributes(italic, range: range)
        case Fonts.underlined:
            isUnderlined ? string.removeAttribute(NSAttributedString.Key.underlineStyle, range: range) : string.addAttributes(underlined, range: range)
        default:
            break
        }
        
        completion(string, range)
    }
    
}

enum Fonts {
    static var bold       = ".SFUI-Semibold"
    static var italic     = ".SFUI-RegularItalic"
    static var underlined = "underlined"
    static var regular    = "regular"
}
