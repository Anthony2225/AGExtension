//
//  AG_Button_Extension.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/22.
//

// MARK: ===================================工具类:用于UIButton 功能的拓展和补充=========================================


import UIKit
import Foundation

public enum HapticType: Int {
    case disabled = 0
    case light = 1

    case medium = 2

    case heavy = 3

    @available(iOS 13.0, *)
    case soft = 4

    @available(iOS 13.0, *)
    case rigid = 5
}
public extension UIButton {
    static let associateKey = "hapticTypeKey"
    fileprivate struct AssociateKey {
        static var associateKey = "hapticTypeKeysssss"
    }
    
    
    /// 按钮震动反馈 默认为 disabled ..如果设置,会在按钮点击的时候震动
    var ag_HapticType: HapticType  {
        get {
            if let hl = objc_getAssociatedObject(self, &AssociateKey.associateKey)  as? HapticType {
                return hl
            }else{
                return .disabled
            }
            
        }
        set {
            print(newValue)
            objc_setAssociatedObject(self, &AssociateKey.associateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
}

public extension UIButton {
    // MARK: -----//// 属性设置   可以用链式调用 \\\\-----
    /// 链式调用 设置button字体
    /// - Parameter font: 字体
    /// - Returns: self
    @discardableResult func ag_Font (_ font:UIFont) -> Self{
        self.titleLabel?.font = font
        return self
    }
    
    /// 链式 设置按钮 根据状态设置文字内容
    /// - Parameters:
    ///   - title: 文字
    ///   - state: 状态
    /// - Returns: self
    @discardableResult func ag_Title(_ title:String?,for state:UIControl.State) -> Self {
        self.setTitle(title, for: state)
        return self
    }
    
    /// 链式 设置按钮字体颜色
    /// - Parameters:
    ///   - color: 字体颜色
    ///   - state: 状态
    /// - Returns: self
    @discardableResult func ag_TitleColor(_ color:UIColor?,for state:UIControl.State)  -> Self {
        self.setTitleColor(color, for: state)
        return self
    }
    
    /// 链式 设置按钮图片
    /// - Parameters:
    ///   - image: button image
    ///   - state: button state
    /// - Returns: self
    @discardableResult func ag_Image(_ image: UIImage?,for state:UIControl.State) -> Self {
        self.setImage(image, for: state)
        return self
    }
    
    ///  链式 设置按钮 背景图片
    /// - Parameters:
    ///   - image: 背景图片
    ///   - state: button state
    /// - Returns: self
    @discardableResult func ag_BgImage(_ image:UIImage?,for state:UIControl.State) -> Self {
        self.setBackgroundImage(image, for: state)
        return self
    }
    
    /// 链式 设置按钮 坐标
    /// - Parameter frame: 坐标
    /// - Returns: self
    @discardableResult func ag_Frame(_ frame:CGRect) -> Self{
        self.frame = frame
        return self
    }
    
    /// 链式 将按钮添加到父视图
    /// - Parameter view: 父视图
    /// - Returns: self
    @discardableResult func ag_AddToSuperView(_ view :UIView) ->Self {
        view.addSubview(self)
        return self
    }
    
    /// 链式 设置按钮背景颜色
    /// - Parameter color: 背景色
    /// - Returns: self
    @discardableResult func ag_BgColor(_ color:UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }
}


// MARK: -----//// 调整button 图片和文字位置\\\\-----

public enum AgImagePosition{
    
    case imagePositionLeft
    case imagePositionRight
    case imagePositionTop
    case imagePositionBottom

}
public extension UIButton {
    
     // TODO: ======ios 15 建议废弃一些属性,,最起码还能用几年 ======
    
    /// UIButton 图文布局 外观大小不固定 固定间距
    /// - Parameters:
    ///   - postion: 布局样式
    ///   - space: 图文间距
    func ag_LayoutButton(_ postion: AgImagePosition = .imagePositionTop, space: CGFloat = 5) {
        
        guard let titleL = titleLabel, let imageV = imageView else {
            return
        }
        
        setTitle(currentTitle, for: .normal)
        setImage(currentImage, for: .normal)
        
        let imageWidth = imageV.frame.size.width
        let imageHeight = imageV.frame.size.height
        
        guard
        let labelWidth = titleL.text?.size(withAttributes: [NSAttributedString.Key.font: titleL.font as UIFont]).width,
        let labelHeight = titleL.text?.size(withAttributes: [NSAttributedString.Key.font: titleL.font as UIFont]).height
        else {
            return
        }
        
        let imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2//image中心移动的x距离
        let imageOffsetY = imageHeight / 2 + space / 2//image中心移动的y距离
        let labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2//label中心移动的x距离
        let labelOffsetY = labelHeight / 2 + space / 2//label中心移动的y距离
        
        let tempWidth = max(labelWidth, imageWidth)
        let changedWidth = labelWidth + imageWidth - tempWidth
        let tempHeight = max(labelHeight, imageHeight);
        let changedHeight = labelHeight + imageHeight + space - tempHeight

        switch postion {
        case .imagePositionTop:
            imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX)
            contentEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: -0.5 * changedWidth, bottom: changedHeight-imageOffsetY, right: -0.5 * changedWidth)
            
        case .imagePositionBottom:
            imageEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: -labelOffsetY, left: -labelOffsetX, bottom:labelOffsetY, right: labelOffsetX)
            contentEdgeInsets = UIEdgeInsets(top: changedHeight-imageOffsetY, left: -0.5 * changedWidth, bottom: imageOffsetY, right: -0.5 * changedWidth)
            
        case .imagePositionRight:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + 0.5 * space, bottom: 0, right: -(labelWidth + 0.5 * space))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageWidth + 0.5 * space), bottom: 0, right: imageWidth + space * 0.5)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * space, bottom: 0, right: 0.5*space)
            
        default:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -0.5 * space, bottom: 0, right: 0.5 * space)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * space, bottom: 0, right: -0.5 * space)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * space, bottom: 0, right: 0.5 * space)
        }
    }
    
    
    /// UIButton 图文布局 外观大小固定
    /// - Parameters:
    ///   - postion: 布局样式
    ///   - margin: 图文距离左右两边
    func ag_LayoutButton(_ postion: AgImagePosition, margin: CGFloat) {
        
        guard
        let imageWidth = imageView?.image?.size.width,
            let labelWidth = titleLabel?.text?.size(withAttributes: [NSAttributedString.Key.font: titleLabel?.font ?? UIFont.systemFont(ofSize: 13)]).width
        else {
            return
        }
        let space = bounds.size.width - imageWidth - labelWidth - 2 * margin
        ag_LayoutButton(postion, space: space)
    }
}


// MARK: -----//// button 点击回调 \\\\-----
public extension UIButton {
    
    /// button 点击回调
    /// - Parameter action: 回调
    @discardableResult
    func tapActionClosures(_ action:@escaping (UIButton) -> Void) -> Self{
        if self.ag_btnActionBlock != nil  {
            return self
        }
        self.ag_btnActionBlock = action
        self.addTarget(self, action: #selector(agBtnAction), for: .touchUpInside)
        return self
    }
    
    @objc private func agBtnAction() {
        switch ag_HapticType {
            case .disabled:
                 debugPrint("no haptic | 没有设置震动反馈")
            case .light:
                AgGenerator.ag_Light()
            case .medium:
                AgGenerator.ag_Medium()
            case .heavy:
                AgGenerator.ag_Heavy()
            case .soft:
                AgGenerator.ag_Soft()
            case .rigid:
                AgGenerator.ag_Rigid()
        }
        self.ag_btnActionBlock?(self)

        
    }
    
    
    private struct ag_associatedKeys{
        static var btnActionKeyName = "ag_btnActionClosuressKey"
    }
    
    
     var ag_btnActionBlock:((_ btn:UIButton) -> Void)? {
        set {
            objc_setAssociatedObject(self, &ag_associatedKeys.btnActionKeyName, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            objc_getAssociatedObject(self, &ag_associatedKeys.btnActionKeyName) as? ((UIButton) -> Void)
        }
    }
    
}
