//
//  SettingViewGreetingView.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/11/23.
//

import Foundation
import UIKit

class PaddingLabel: UILabel {
    var topPadding: CGFloat = 0.0
    var leftPadding: CGFloat = 0.0
    var bottomPadding: CGFloat = 0.0
    var rightPadding: CGFloat = 0.0
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.topPadding = padding.top
        self.leftPadding = padding.left
        self.bottomPadding = padding.bottom
        self.rightPadding = padding.right    }
    
    override func drawText(in rect: CGRect) {
        let padding = UIEdgeInsets.init(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
        super.drawText(in: rect.inset(by: padding))
    }
    
    //안의 내재되어있는 콘텐트의 사이즈에 따라 height와 width에 padding값을 더해줌
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += self.leftPadding + self.rightPadding
        contentSize.height += self.topPadding + self.bottomPadding
        return contentSize
    }
}
