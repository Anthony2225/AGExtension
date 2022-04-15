//
//  AG_UILabel_Extension.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/22.
//

import Foundation
import UIKit

// MARK: ===================================工具类:用于拓展和=========================================


public extension UILabel {
    @discardableResult func ag_Config(_ config:(_ label: UILabel) -> Void)  -> Self {
        config(self)
        return self
    }
    
    /// 链式设置 label 文字内容
    /// - Parameter text: 文字内容
    /// - Returns: self
    @discardableResult func ag_Text(_ text:String?)  -> Self {
        self.text = text
        return self
    }
    
    /// 链式 设置label 字体
    /// - Parameter font: label  font
    /// - Returns: self
    @discardableResult func ag_Font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    
    /// 链式 设置 label 字体颜色
    /// - Parameter color: 字体颜色
    /// - Returns: self
    @discardableResult func ag_TextColor(_ color: UIColor?) -> Self {
        self.textColor = color
        return self
    }
    
    /// 链式 设置 label 背景色
    /// - Parameter color: 背景色
    /// - Returns: self
    @discardableResult func ag_BgColor(_ color : UIColor?) -> Self{
        self.backgroundColor = color
        return self
    }
    
    
    /// 链式 设置 label 行数
    /// - Parameter num: 行
    /// - Returns: self
    @discardableResult func ag_NumberOfLines(_ num: Int) -> Self {
        self.numberOfLines = num
        return self
    }
    
    /// 链式 设置 label 文字对齐方式
    /// - Parameter alignment: 对齐方式
    /// - Returns: self
    @discardableResult func ag_TextAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    
    /// 链式 设置 label 的坐标
    /// - Parameter frame: 坐标
    /// - Returns: self
    @discardableResult func ag_Frame(_ frame:CGRect) -> Self{
        self.frame = frame
        return self
    }
    
    /// 链式 将label 添加到父视图
    /// - Parameter view: 父视图
    /// - Returns: self
    @discardableResult func ag_AddToSuperView(_ view :UIView) -> Self{
        view.addSubview(self)
        return self
    }
    
    /// 链式 设置自定义属性,是否允许长按复制 label 的文字
    /// - Parameter isCanCopy: bool
    /// - Returns: self
    @discardableResult func ag_IsCopyingEnabled(_ isCanCopy: Bool) -> Self {
        self.isCopyingEnabled = isCanCopy
        return self
    }
}

// MARK: -----//// 给 UILabel 添加默认的 点击手势回调,和长按显示复制\\\\-----
public extension UILabel {
    
    private struct AssociatedKeys{
        // 给 label 增加 单击手势 以及回调
        static var tapGestureRecognizer = "tapGestureRecognizer"
        static var labelTapAction = "labelTapAction"
        
        // 给 label 增加长按复制功能
        static var isCopyingEnabled = "isCopyingEnabled"
        static var longPressGestureRecognizer = "longPressGestureRecognizer"

    }
     // MARK: -----//// 给 UILabel 添加 长按复制手势\\\\-----
    /// 是否开启长按复制功能
    @objc @IBInspectable var isCopyingEnabled: Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isCopyingEnabled, newValue, .OBJC_ASSOCIATION_ASSIGN)
            setupLonfPressGes()
        }
        get {
            let value = objc_getAssociatedObject(self, &AssociatedKeys.isCopyingEnabled)
            return (value as? Bool) ?? false
        }
    }
    
    @objc private var longPressGestureRecognizer:UILongPressGestureRecognizer? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.longPressGestureRecognizer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.longPressGestureRecognizer) as? UILongPressGestureRecognizer
        }
    }
    
    @objc private func longPressGestureAction(longPreGes:UILongPressGestureRecognizer){
        if longPreGes == longPressGestureRecognizer && longPreGes.state == .began {
            becomeFirstResponder()
        }
        let copyMenu = UIMenuController.shared
        copyMenu.arrowDirection = .default
        if #available(iOS 13.0, *) {
            copyMenu.showMenu(from: self, rect: bounds)
        }else{
            //13系统之前的
            copyMenu.setTargetRect(bounds, in: self)
            copyMenu.setMenuVisible(true, animated: true)
        }
    }
    @objc func  copyText(_ sender:UIMenuController) {
        if isCopyingEnabled {
            let pasteboard = UIPasteboard.general
            pasteboard.string = text
        }
    }
    @objc override func copy(_ sender: Any?) {
        if isCopyingEnabled {
            let pasteboard = UIPasteboard.general
            pasteboard.string = text
        }
    }
    /// 要使用弹出复制的那个窗口 ,需要重写这个属性
    @objc override var canBecomeFirstResponder: Bool {
        return isCopyingEnabled
    }
    
    fileprivate func setupLonfPressGes() {
       // 删除手势
        if let longPress = longPressGestureRecognizer {
            removeGestureRecognizer(longPress)
            longPressGestureRecognizer = nil
        }
        
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureAction(longPreGes:)))
        longPressGestureRecognizer = longPressGes
        addGestureRecognizer(longPressGes)
        
    }
    
    
    
    // MARK: -----//// 给 label 默认添加一个手势,,并添加链式回调\\\\-----
    /// 链式 UILabel 默认添加 tap 手势回调
    /// - Parameter tapAction: 手势点击回调
    /// - Returns: self
    @discardableResult func ag_TapLabel(_ tapAction:@escaping (UILabel,UITapGestureRecognizer) -> Void)  -> Self{
        self.isUserInteractionEnabled = true
        if self.ag_labelTapBlock != nil {
            return self
        }
        self.ag_labelTapBlock = tapAction
        setupTapGestureRecognizers()
        return self
    }
    
    // 单击手势
    @objc private var  tapGestureRecognizer:UITapGestureRecognizer? {
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.tapGestureRecognizer, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.tapGestureRecognizer) as? UITapGestureRecognizer
        }
    }
    
    
    // 单击手势的 action
    @objc private func labelTap(tap:UITapGestureRecognizer) {
        if tap == tapGestureRecognizer {
            self.ag_labelTapBlock?(self,tap)

        }
        
    }
    
    /// label单击的回调
    private var  ag_labelTapBlock:((_ label:UILabel , _ tap:UITapGestureRecognizer) -> Void)? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.labelTapAction, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.labelTapAction) as? ((_ label:UILabel , _ tap: UITapGestureRecognizer) -> Void)
        }
    }
    
    // 初始化单击手势
    fileprivate func setupTapGestureRecognizers() {
        if let tapGes = tapGestureRecognizer {
            removeGestureRecognizer(tapGes)
            tapGestureRecognizer = nil
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelTap(tap:)))
        tapGestureRecognizer = tap
        addGestureRecognizer(tap)
    }
}
