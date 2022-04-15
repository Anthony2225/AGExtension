//
//  AG_Int_Extension.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/23.
//

import Foundation
import UIKit

public extension Int {
    
    /// 默认字体
    var ag_Font: UIFont {
        return UIFont.systemFont(ofSize: CGFloat(self))
    }
    
    /// medium字
    var ag_FontMedium: UIFont {
        return UIFont.systemFont(ofSize: CGFloat(self), weight: .medium)
    }
    
    ///  bold 字
    var ag_FontBold: UIFont {
        return UIFont.boldSystemFont(ofSize: CGFloat(self))
    }

    /// italic 字
    var ag_FontItalic: UIFont {
        return UIFont.italicSystemFont(ofSize: CGFloat(self))
    }

    /// 字体拓展
    func ag_Font(withName name: String) -> UIFont? {
        return UIFont(name: name, size: CGFloat(self))
    }
    
}
