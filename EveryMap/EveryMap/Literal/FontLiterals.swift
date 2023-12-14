//
//  FontLiterals.swift
//  EveryMap
//
//  Created by 이성현 on 2023/12/14.
//

import Foundation
import UIKit

extension UIFont {
    @nonobjc class var h1: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 32)
    }
    
    @nonobjc class var b1: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 26)
    }
    
    @nonobjc class var b2: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 20)
    }
}

enum FontName: String {
    case pretendardBold = "Pretendard-Bold"
    case pretendardSemiBold = "Pretendard-SemiBold"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardRegular = "Pretendard-Regular"
}

extension UIFont {
    static func font(_ style: FontName, ofSize size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }
}
