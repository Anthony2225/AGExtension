//
//  AG_Badge.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/28.
//

import Foundation
import UIKit

/// 伸缩方向
public enum AgBadgeFiexMode {
    case head  //左    <--*
    case tail  // 右     *-->
    case middle // 左右   <--*-->
}
private var aBadgeView = "aBadgeView"
/*  用法
 e.g.         btn.gg.addBadge(text: "123")
 btn.gg.badgeView.shakeAnimation()  加动画 加载 gg.badgeView 上

 addBadge(text: String)
 addBadge(number: Int)
 addDot(color: UIColor?)
 moveBadge(x: CGFloat, y: CGFloat)
 setBadge(flexMode: PPBadgeViewFlexMode = .tail)
 setBadge(height: CGFloat)
 setFont(font:CGFloat)
 showBadge()
 hiddenBadge()
 increase()
 increaseBy(number: Int)
 decrease()
 decreaseBy(number: Int)
 */

// MARK: ===================================工具类:小红点=========================================

open class AgBadgeControl: UIControl {
    
    /// badge 伸缩的方向,
    public var flexMode: AgBadgeFiexMode = .tail
    
    /// 记录用
    public var offset: CGPoint = CGPoint(x: 0, y: 0)
    
    private lazy var textLable: UILabel = UILabel()
    
    private lazy var imageView: UIImageView = UIImageView()
    
    
    private var badgeViewColor: UIColor?
    
    private var badgeViewHeightConstranint: NSLayoutConstraint?
    
    
    public class func `default`() -> Self{
        return self.init(frame: .zero)
    }
    
    required override public init(frame: CGRect) {
        super.init(frame: frame )
        setupSubviews()

    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    /// set text
    open var text: String? {
        didSet {
            textLable.text = text
        }
    }
    /// set attibutedtext
    open var attributedText: NSAttributedString? {
        didSet {
            textLable.attributedText = attributedText
        }
    }
    
    open var font: UIFont? {
        didSet {
            textLable.font = font
        }
    }
    
    open var backgroundImage: UIImage?{
        didSet{
            imageView.image = backgroundImage
            
            if let _ = backgroundImage {
                if let constraint = heightConstraint() {
                    badgeViewHeightConstranint = constraint
                    removeConstraint(constraint)
                }
                backgroundColor = .clear
            }else{
                if heightConstraint() == nil ,let constraint = badgeViewHeightConstranint {
                    addConstraint(constraint)
                }
                backgroundColor = badgeViewColor
            }
        }
    }
    
    
    open override var backgroundColor: UIColor?{
        didSet {
            super.backgroundColor = backgroundColor
            if let  color = backgroundColor,color != .clear{
                badgeViewColor = backgroundColor
            }
        }
    }
    
    
    private func setupSubviews() {
        layer .masksToBounds = true
        layer.cornerRadius  = 9.0
        // 设置为 false  防止有些布局约束冲突  https://www.jianshu.com/p/0d12ba3a3e9c
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .red
        textLable.textColor = .white
        textLable.font = .systemFont(ofSize: 13)
        textLable.textAlignment = .center
        addSubview(textLable)
        addSubview(imageView)
        addLayout(with: imageView, leading: 0, trailing: 0)
        addLayout(with: textLable, leading: 5, trailing: -5)
    }
    
    private func addLayout(with view: UIView, leading: CGFloat, trailing: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: leading)
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: trailing)
        leadingConstraint.priority = UILayoutPriority(rawValue: 999)
        trailingConstraint.priority = UILayoutPriority(rawValue: 999)
        addConstraints([topConstraint, leadingConstraint, bottomConstraint, trailingConstraint])
    }

}



extension UIView {

    public var badgeView: AgBadgeControl {
        get {
            if let aValue = objc_getAssociatedObject(self, &aBadgeView) as? AgBadgeControl {
                return aValue
            }
            else {
                let badgeControl = AgBadgeControl.default()
                self.addSubview(badgeControl)
                self.bringSubviewToFront(badgeControl)
                self.badgeView = badgeControl
                self.addBadgeViewLayoutConstraint()
                return badgeControl
            }
        }
        set {
            objc_setAssociatedObject(self, &aBadgeView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal func topConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .top)
    }
    
    internal func leadingConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .leading)
    }
    
    internal func bottomConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .bottom)
    }

    internal func trailingConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .trailing)
    }
    
    internal func widthConstraint() -> NSLayoutConstraint? {
        return constraint(with: self, attribute: .width)
    }
    
    internal func heightConstraint() -> NSLayoutConstraint? {
        return constraint(with: self, attribute: .height)
    }

    internal func centerXConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .centerX)
    }
    
    internal func centerYConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .centerY)
    }
    
    private func constraint(with item: AnyObject?, attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        for constraint in constraints {
            if let isSame = constraint.firstItem?.isEqual(item), isSame, constraint.firstAttribute == attribute {
                return constraint
            }
        }
        return nil
    }
    
    
    private func addBadgeViewLayoutConstraint() {
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        let centerXConstraint = NSLayoutConstraint(item: badgeView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: badgeView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: badgeView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: badgeView, attribute: .height, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: badgeView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 18)
        addConstraints([centerXConstraint, centerYConstraint])
        badgeView.addConstraints([widthConstraint, heightConstraint])
    }
}


public struct GG<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public extension NSObjectProtocol {
    var gg: GG<Self>{
        return GG(self)
    }
}



// MARK: ===================================小红点 UIView 拓展 =========================================

public extension GG  where Base: UIView{
    var badgeView: AgBadgeControl {
        return base.badgeView
    }
    
    func addBadge(text: String?)  {
        showBadge()
        base.badgeView.text = text
        setBadge(flexMode: base.badgeView.flexMode)

        if text == nil {
            if base.badgeView.widthConstraint()?.relation == .equal {return}
            base.badgeView.widthConstraint()?.isActive = false
            
            let constraint = NSLayoutConstraint(item: base.badgeView, attribute: .width, relatedBy: .equal, toItem: base.badgeView, attribute: .height, multiplier: 1.0, constant: 0)
            base.badgeView.addConstraint(constraint)
            
        }else{
            if base.badgeView.widthConstraint()?.relation == .greaterThanOrEqual { return }
            base.badgeView.widthConstraint()?.isActive = false
            let constraint = NSLayoutConstraint(item: base.badgeView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: base.badgeView, attribute: .height, multiplier: 1.0, constant: 0)
            base.badgeView.addConstraint(constraint)
        }
        
    }
    
    /// 添加带数字的Badge, 默认右上角,红色,18pts
    ///
    /// Add the Badge with numbers, the default upper right corner, red backgroundColor, 18pts
    ///
    /// - Parameter number: 整形数字
    func addBadge(number: Int) {
        if number <= 0 {
            addBadge(text: "0")
            hiddenBadge()
            return
        }
        addBadge(text: "\(number)")
    }
    
    /// 添加带颜色的小圆点, 默认右上角, 红色, 8pts
    ///
    /// Add small dots with color, the default upper right corner, red backgroundColor, 8pts
    ///
    /// - Parameter color: 颜色
    func addDot(color: UIColor? = .red) {
        addBadge(text: nil)
        setBadge(height: 8.0)
        base.badgeView.backgroundColor = color
    }
    /// 显示Badge
    func showBadge() {
        base.badgeView.isHidden = false
    }
    
    /// 隐藏Badge
    func hiddenBadge() {
        base.badgeView.isHidden = true
    }
    /// 设置Badge伸缩的方向
    ///
    /// Setting the direction of Badge expansion
    ///
    /// PPBadgeViewFlexModeHead,    左伸缩 Head Flex    : <==●
    /// PPBadgeViewFlexModeTail,    右伸缩 Tail Flex    : ●==>
    /// PPBadgeViewFlexModeMiddle   左右伸缩 Middle Flex : <=●=>
    /// - Parameter flexMode : Default is PPBadgeViewFlexModeTail
    func setBadge(flexMode: AgBadgeFiexMode = .tail) {
        base.badgeView.flexMode = flexMode
        moveBadge(x: base.badgeView.offset.x, y: base.badgeView.offset.y)
    }
    
    
    
    /// 设置Badge的偏移量, Badge中心点默认为其父视图的右上角
    ///
    /// Set Badge offset, Badge center point defaults to the top right corner of its parent view
    ///
    /// - Parameters:
    ///   - x: X轴偏移量 (x<0: 左移, x>0: 右移) axis offset (x <0: left, x> 0: right)
    ///   - y: Y轴偏移量 (y<0: 上移, y>0: 下移) axis offset (Y <0: up,   y> 0: down)
    func moveBadge(x: CGFloat, y: CGFloat) {
        base.badgeView.offset = CGPoint(x: x, y: y)
        base.centerYConstraint(with: base.badgeView)?.constant = y
        
        let badgeHeight = base.badgeView.heightConstraint()?.constant ?? 0
        switch base.badgeView.flexMode {
        case .head:
            base.centerXConstraint(with: base.badgeView)?.isActive = false
            base.leadingConstraint(with: base.badgeView)?.isActive = false
            if let constraint = base.trailingConstraint(with: base.badgeView) {
                constraint.constant = badgeHeight * 0.5 + x
                return
            }
            let trailingConstraint = NSLayoutConstraint(item: base.badgeView, attribute: .trailing, relatedBy: .equal, toItem: base, attribute: .trailing, multiplier: 1.0, constant: badgeHeight * 0.5 + x)
            base.addConstraint(trailingConstraint)
            
        case .tail:
            base.centerXConstraint(with: base.badgeView)?.isActive = false
            base.trailingConstraint(with: base.badgeView)?.isActive = false
            if let constraint = base.leadingConstraint(with: base.badgeView) {
                constraint.constant = x - badgeHeight * 0.5
                return
            }
            let leadingConstraint = NSLayoutConstraint(item: base.badgeView, attribute: .leading, relatedBy: .equal, toItem: base, attribute: .trailing, multiplier: 1.0, constant: x - badgeHeight * 0.5)
            base.addConstraint(leadingConstraint)
            
        case .middle:
            base.leadingConstraint(with: base.badgeView)?.isActive = false
            base.trailingConstraint(with: base.badgeView)?.isActive = false
            base.centerXConstraint(with: base.badgeView)?.constant = x
            if let constraint = base.centerXConstraint(with: base.badgeView) {
                constraint.constant = x
                return
            }
            let centerXConstraint = NSLayoutConstraint(item: base.badgeView, attribute: .centerX, relatedBy: .equal, toItem: base, attribute: .centerX, multiplier: 1.0, constant: x)
            base.addConstraint(centerXConstraint)
        }
    }
    
    
    // 设置Badge的高度,因为Badge宽度是动态可变的,通过改变Badge高度,其宽度也按比例变化,方便布局
    ///
    /// (注意: 此方法需要将Badge添加到控件上后再调用!!!)
    ///
    /// Set the height of Badge, because the Badge width is dynamically and  variable.By changing the Badge height in proportion to facilitate the layout.
    ///
    /// (Note: this method needs to add Badge to the controls and then use it !!!)
    ///
    /// - Parameter height: 高度大小
    func setBadge(height: CGFloat) {
        base.badgeView.layer.cornerRadius = height * 0.5
        base.badgeView.heightConstraint()?.constant = height
        moveBadge(x: base.badgeView.offset.x, y: base.badgeView.offset.y)
    }
    ///设置字体
    func setFont(font:CGFloat)  {
        base.badgeView.font = UIFont(name:  "PingFang-SC-Regular", size: font)
    }
 
    
    // MARK: - 数字增加/减少, 注意:以下方法只适用于Badge内容为纯数字的情况
    // MARK: - Digital increase /decrease, note: the following method applies only to cases where the Badge content is purely numeric
    /// badge数字加1
    func increase() {
        increaseBy(number: 1)
    }
    
    /// badge数字加number
    func increaseBy(number: Int) {
        let label = base.badgeView
        let result = (Int(label.text ?? "0") ?? 0) + number
        if result > 0 {
            showBadge()
        }
        label.text = "\(result)"
    }
    
    /// badge数字减1
    func decrease() {
        decreaseBy(number: 1)
    }
    
    /// badge数字减number
    func decreaseBy(number: Int) {
        let label = base.badgeView
        let result = (Int(label.text ?? "0") ?? 0) - number
        if (result <= 0) {
            hiddenBadge()
            label.text = "0"
            return
        }
        label.text = "\(result)"
    }
}


// MARK: -----//// Tabbar 拓展 \\\\-----

public extension GG where Base: UITabBarItem {
    
    var badgeView: AgBadgeControl {
        return _bottomView.gg.badgeView
    }
    
    /// 添加带文本内容的Badge, 默认右上角, 红色, 18pts
    ///
    /// Add Badge with text content, the default upper right corner, red backgroundColor, 18pts
    ///
    /// - Parameter text: 文本字符串
    func addBadge(text: String) {
        _bottomView.gg.addBadge(text: text)
        _bottomView.gg.moveBadge(x: 4, y: 3)
    }
    
    /// 添加带数字的Badge, 默认右上角,红色,18pts
    ///
    /// Add the Badge with numbers, the default upper right corner, red backgroundColor, 18pts
    ///
    /// - Parameter number: 整形数字
    func addBadge(number: Int) {
        _bottomView.gg.addBadge(number: number)
        _bottomView.gg.moveBadge(x: 4, y: 3)
    }
    
    /// 添加带颜色的小圆点, 默认右上角, 红色, 8pts
    ///
    /// Add small dots with color, the default upper right corner, red backgroundColor, 8pts
    ///
    /// - Parameter color: 颜色
    func addDot(color: UIColor?) {
        _bottomView.gg.addDot(color: color)
    }
    
    /// 设置Badge的偏移量, Badge中心点默认为其父视图的右上角
    ///
    /// Set Badge offset, Badge center point defaults to the top right corner of its parent view
    ///
    /// - Parameters:
    ///   - x: X轴偏移量 (x<0: 左移, x>0: 右移) axis offset (x <0: left, x> 0: right)
    ///   - y: Y轴偏移量 (y<0: 上移, y>0: 下移) axis offset (Y <0: up,   y> 0: down)
    func moveBadge(x: CGFloat, y: CGFloat) {
        _bottomView.gg.moveBadge(x: x, y: y)
    }
    
    /// 设置Badge伸缩的方向
    ///
    /// Setting the direction of Badge expansion
    ///
    /// PPBadgeViewFlexModeHead,    左伸缩 Head Flex    : <==●
    /// PPBadgeViewFlexModeTail,    右伸缩 Tail Flex    : ●==>
    /// PPBadgeViewFlexModeMiddle   左右伸缩 Middle Flex : <=●=>
    /// - Parameter flexMode : Default is PPBadgeViewFlexModeTail
    func setBadge(flexMode: AgBadgeFiexMode = .tail) {
        _bottomView.gg.setBadge(flexMode: flexMode)
    }
    
    /// 设置Badge的高度,因为Badge宽度是动态可变的,通过改变Badge高度,其宽度也按比例变化,方便布局
    ///
    /// (注意: 此方法需要将Badge添加到控件上后再调用!!!)
    ///
    /// Set the height of Badge, because the Badge width is dynamically and  variable.By changing the Badge height in proportion to facilitate the layout.
    ///
    /// (Note: this method needs to add Badge to the controls and then use it !!!)
    ///
    /// - Parameter height: 高度大小
    func setBadge(height: CGFloat) {
        _bottomView.gg.setBadge(height: height)
    }
    
    
    /// 显示Badge
    func showBadge() {
        _bottomView.gg.showBadge()
    }
    
    /// 隐藏Badge
    func hiddenBadge() {
        _bottomView.gg.hiddenBadge()
    }
    
    // MARK: - 数字增加/减少, 注意:以下方法只适用于Badge内容为纯数字的情况
    // MARK: - Digital increase /decrease, note: the following method applies only to cases where the Badge content is purely numeric
    /// badge数字加1
    func increase() {
        _bottomView.gg.increase()
    }
    
    /// badge数字加number
    func increaseBy(number: Int) {
        _bottomView.gg.increaseBy(number: number)
    }
    
    /// badge数字加1
    func decrease() {
        _bottomView.gg.decrease()
    }
    
    /// badge数字减number
    func decreaseBy(number: Int) {
        _bottomView.gg.decreaseBy(number: number)
    }
    
    
    
    private var _bottomView: UIView {
        let tabBarButton = (self.base.value(forKey: "_view") as? UIView) ?? UIView()
        for subView  in tabBarButton.subviews {
            guard let superclass = subView.superclass else { return tabBarButton }
            if superclass == NSClassFromString("UIImageView") {
                return subView
            }
        }
        return tabBarButton
    }
}



// MARK: -----//// uibarButtonItem 小红点拓展 \\\\-----


public extension GG where Base:UIBarButtonItem {
    var badgeView: AgBadgeControl {
        return _bottomView.gg.badgeView
    }
    
    /// 添加带文本内容的Badge, 默认右上角, 红色, 18pts
    ///
    /// Add Badge with text content, the default upper right corner, red backgroundColor, 18pts
    ///
    /// - Parameter text: 文本字符串
    func addBadge(text: String) {
        _bottomView.gg.addBadge(text: text)
    }
    
    /// 添加带数字的Badge, 默认右上角,红色,18pts
    ///
    /// Add the Badge with numbers, the default upper right corner, red backgroundColor, 18pts
    ///
    /// - Parameter number: 整形数字
    func addBadge(number: Int) {
        _bottomView.gg.addBadge(number: number)
    }
    
    /// 添加带颜色的小圆点, 默认右上角, 红色, 8pts
    ///
    /// Add small dots with color, the default upper right corner, red backgroundColor, 8pts
    ///
    /// - Parameter color: 颜色
    func addDot(color: UIColor?) {
        _bottomView.gg.addDot(color: color)
    }
    
    /// 设置Badge的偏移量, Badge中心点默认为其父视图的右上角
    ///
    /// Set Badge offset, Badge center point defaults to the top right corner of its parent view
    ///
    /// - Parameters:
    ///   - x: X轴偏移量 (x<0: 左移, x>0: 右移) axis offset (x <0: left, x> 0: right)
    ///   - y: Y轴偏移量 (y<0: 上移, y>0: 下移) axis offset (Y <0: up,   y> 0: down)
    func moveBadge(x: CGFloat, y: CGFloat) {
        _bottomView.gg.moveBadge(x: x, y: y)
    }
    
    /// 设置Badge伸缩的方向
    ///
    /// Setting the direction of Badge expansion
    ///
    /// PPBadgeViewFlexModeHead,    左伸缩 Head Flex    : <==●
    /// PPBadgeViewFlexModeTail,    右伸缩 Tail Flex    : ●==>
    /// PPBadgeViewFlexModeMiddle   左右伸缩 Middle Flex : <=●=>
    /// - Parameter flexMode : Default is PPBadgeViewFlexModeTail
    func setBadge(flexMode: AgBadgeFiexMode = .tail) {
        _bottomView.gg.setBadge(flexMode: flexMode)
    }
    
    /// 设置Badge的高度,因为Badge宽度是动态可变的,通过改变Badge高度,其宽度也按比例变化,方便布局
    ///
    /// (注意: 此方法需要将Badge添加到控件上后再调用!!!)
    ///
    /// Set the height of Badge, because the Badge width is dynamically and  variable.By changing the Badge height in proportion to facilitate the layout.
    ///
    /// (Note: this method needs to add Badge to the controls and then use it !!!)
    ///
    /// - Parameter points: 高度大小
    func setBadge(height: CGFloat) {
        _bottomView.gg.setBadge(height: height)
    }
    
    /// 显示Badge
    func showBadge() {
        _bottomView.gg.showBadge()
    }
    
    /// 隐藏Badge
    func hiddenBadge() {
        _bottomView.gg.hiddenBadge()
    }
    
    // MARK: - 数字增加/减少, 注意:以下方法只适用于Badge内容为纯数字的情况
    // MARK: - Digital increase /decrease, note: the following method applies only to cases where the Badge content is purely numeric
    /// badge数字加1
    func increase() {
        _bottomView.gg.increase()
    }
    
    /// badge数字加number
    func increaseBy(number: Int) {
        _bottomView.gg.increaseBy(number: number)
    }
    
    /// badge数字加1
    func decrease() {
        _bottomView.gg.decrease()
    }
    
    /// badge数字减number
    func decreaseBy(number: Int) {
        _bottomView.gg.decreaseBy(number: number)
    }

    /// 通过Xcode视图调试工具找到UIBarButtonItem的Badge所在父视图为:UIImageView
    private var _bottomView: UIView {
        let navigationButton = (self.base.value(forKey: "_view") as? UIView) ?? UIView()
        let systemVersion = (UIDevice.current.systemVersion as NSString).doubleValue
        let controlName = (systemVersion < 11.0 ? "UIImageView" : "UIButton" )
        for subView in navigationButton.subviews {
            if subView.isKind(of: NSClassFromString(controlName)!) {
                subView.layer.masksToBounds = false
                return subView
            }
        }
        return navigationButton
    }
}
