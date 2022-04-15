//
//  AG_UITextView_Extension.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/28.
//

import Foundation
import UIKit

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
                return .darkText
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
            _holderLabel.textColor = .darkText
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
        
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 7, left: 2, bottom: 0, right: 0))
        }
    }
    
    /// 编辑事件
    @objc fileprivate func ag_textChange(noti: NSNotification) {
        let isEmpty = text.isEmpty
        print("text:\(String(describing: text))\nisEmpty:\(isEmpty)")
        ag_HolderLabel.text = isEmpty ? ag_Placeholder: ""
        ag_HolderLabel.isHidden = !isEmpty
    }
}
