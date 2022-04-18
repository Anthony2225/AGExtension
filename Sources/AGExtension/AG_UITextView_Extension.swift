//
//  AG_UITextView_Extension.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/28.
//

import Foundation
import UIKit
// MARK: ===================================拓展类:用于UITextView 和 UITextField=========================================

public extension UITextView {
    
    fileprivate struct AssiciatedKey{
        static var AGextViewPlaceholderLabel: Int = 0x2019_00
        static var AGextViewPlaceholder     : Int = 0x2019_01
        static var AGextViewPlaceholderColor: Int = 0x2019_02
        static var AGextViewPlaceholderFont : Int = 0x2019_03
        static var AGextViewPlaceholderKeys : Int = 0x2019_04
    }
    /// 占位符
    var ag_Placeholder: String {
        get {
            if let placeholder = objc_getAssociatedObject(self, &AssiciatedKey.AGextViewPlaceholder) as? String {
                return placeholder
            } else {
                return ""
            }
        }
        set {
            objc_setAssociatedObject(self, &AssiciatedKey.AGextViewPlaceholder, newValue, .OBJC_ASSOCIATION_RETAIN)
            ag_HolderLabel.text = newValue
        }
    }
    
    /// 占位符颜色
    var ag_HolderColor: UIColor {
        get {
            if let placeholderColor = objc_getAssociatedObject(self, &AssiciatedKey.AGextViewPlaceholderColor) as? UIColor {
                return placeholderColor
            } else {
                return .gray
            }
        }
        set {
            objc_setAssociatedObject(self, &AssiciatedKey.AGextViewPlaceholderColor, newValue, .OBJC_ASSOCIATION_RETAIN)
            ag_HolderLabel.textColor = newValue
        }
    }
    
    /// 占位符字体
    var ag_HolderFont: UIFont {
        get {
            if let placeholderFont = objc_getAssociatedObject(self, &AssiciatedKey.AGextViewPlaceholderFont) as? UIFont {
                return placeholderFont
            } else {
                return UIFont.systemFont(ofSize: 12)
            }
        }
        set {
            objc_setAssociatedObject(self, &AssiciatedKey.AGextViewPlaceholderFont, newValue, .OBJC_ASSOCIATION_RETAIN)
            ag_HolderLabel.font = newValue
        }
    }
    
    /// 占位符 标签
    var ag_HolderLabel: UILabel {
        get {
            var _holderLabel = UILabel()
            _holderLabel.font = font ?? UIFont.systemFont(ofSize: 12)
            _holderLabel.textColor = .gray
            _holderLabel.textAlignment = .left
            if let label = objc_getAssociatedObject(self, &AssiciatedKey.AGextViewPlaceholderLabel) as? UILabel {
                _holderLabel = label
            } else {
                objc_setAssociatedObject(self, &AssiciatedKey.AGextViewPlaceholderLabel, _holderLabel, .OBJC_ASSOCIATION_RETAIN)
            }
            
            addPlaceholderLabelToSuperView(label: _holderLabel)
            
            return _holderLabel
        }
        set {
            objc_setAssociatedObject(self, &AssiciatedKey.AGextViewPlaceholderLabel, newValue, .OBJC_ASSOCIATION_RETAIN)
            addPlaceholderLabelToSuperView(label: newValue)
        }
    }
    
    /// 是否需要添加占位符到父视图
    fileprivate var holderNeedAddToSuperView: Bool {
        get {
            if let isAdded = objc_getAssociatedObject(self, &AssiciatedKey.AGextViewPlaceholderKeys) as? Bool {
                return isAdded
            }
            return true
        }
        set {
            objc_setAssociatedObject(self, &AssiciatedKey.AGextViewPlaceholderKeys, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 添加占位符到父视图
    ///
    /// - Parameter label: 占位符 标签
    fileprivate func addPlaceholderLabelToSuperView(label: UILabel) {
        
        guard holderNeedAddToSuperView else { return }
        holderNeedAddToSuperView = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(ag_textChange(noti:)), name: UITextView.textDidChangeNotification, object: nil)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
         
        label.topAnchor.constraint(equalTo: label.superview!.topAnchor, constant: 7).isActive = true
        label.leftAnchor.constraint(equalTo: label.superview!.leftAnchor,constant: 4).isActive = true
        label.bottomAnchor.constraint(equalTo: label.superview!.bottomAnchor,constant: 0).isActive  = true
        label.widthAnchor.constraint(equalTo: label.superview!.widthAnchor,constant: -10).isActive = true
    }
    
    /// 编辑事件
    @objc fileprivate func ag_textChange(noti: NSNotification) {
        let isEmpty = text.isEmpty
        print("text:\(String(describing: text))\nisEmpty:\(isEmpty)")
        ag_HolderLabel.text = isEmpty ? ag_Placeholder: ""
        ag_HolderLabel.isHidden = !isEmpty
    }
}



public extension UITextField {
    

    /// 设置自定义的占位符
    /// - Parameters:
    ///   - placeHolder: 占位符内容
    ///   - font: 占位符字体
    ///   - placeHolderColor: 占位符颜色
    func ag_Placeholder(placeHolder: String ,
                        font : UIFont = .systemFont(ofSize: 13),
                        placeHolderColor: UIColor = UIColor.placeholderText) {
        self.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes:[NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeHolderColor] )
    }


}
