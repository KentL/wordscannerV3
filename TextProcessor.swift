//
//  TextProcessor.swift
//  Word Scanner
//
//  Created by Kent Li on 2016-11-17.
//  Copyright © 2016 UPEICS. All rights reserved.
//

import Foundation

class TextProcessor {
    
    // Pinyin: standard system of romanized spelling for transliterating Chinese.
    func AddPinyinToText(text:String) -> String {
        var result = ""
        for c in text.characters {
            result.append(c)
            let cAsString = String(c)
            if cAsString.containsChineseCharacters
            {
                let transformContents = CFStringCreateMutableCopy(nil, 0, cAsString)
                CFStringTransform(transformContents, nil, kCFStringTransformMandarinLatin, false)
                let pinyin = String(transformContents)
                result.appendContentsOf("(\(pinyin))")
            }
        }
        return result
    }
}

extension String {
    var containsChineseCharacters: Bool {
        return self.rangeOfString("\\p{Han}", options: .RegularExpressionSearch) != nil
    }
}