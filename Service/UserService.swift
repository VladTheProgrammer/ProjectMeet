//
//  UserService.swift
//  project18
//
//  Created by Vladimir Kisselev on 2018-03-20.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import Foundation

class UserService {
    
    static func processDisplayText(string: String, fontSize: CGFloat?, fontColor: UIColor?, fontJustify: NSTextAlignment?, fontWeight: UIFont.Weight?) -> NSMutableAttributedString {
        
        var color = UIColor.black
        
        var size = CGFloat(18)
        
        var justify = NSTextAlignment.center
        
        var weight = UIFont.Weight.medium
        
        if fontColor != nil {
            color = fontColor!
        }
        if fontSize != nil {
            size = fontSize!
        }
        if fontJustify != nil {
            justify = fontJustify!
        }
        if fontWeight != nil {
            weight = fontWeight!
        }
        
        let attributedText = NSMutableAttributedString(string: string, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: size, weight: weight), NSAttributedStringKey.foregroundColor : color])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = justify
        let length = attributedText.string.count
        attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: length))
        return attributedText
    }
    
    static func updateTextFont(textView: UITextView) {
        if (textView.text.isEmpty || textView.bounds.size.equalTo(CGSize(width: 0, height: 0))) {
            return;
        }
        
        let textViewSize = textView.frame.size;
        let fixedWidth = textViewSize.width;
        let expectSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)));
        
        var expectFont = textView.font;
        if (expectSize.height > textViewSize.height) {
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = textView.font!.withSize(textView.font!.pointSize - 1)
                textView.font = expectFont
            }
        }
        else {
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = textView.font;
                textView.font = textView.font!.withSize(textView.font!.pointSize + 1)
            }
            textView.font = expectFont;
        }
    }
    
    static func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    
//    static func nextInArray(array: Array<Any>){
//        let first = array.first
////        array.append(first)
////        array.removeFirst()
//    }
}
