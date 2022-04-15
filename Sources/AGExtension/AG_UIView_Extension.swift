//
//  AG_UIView_Extension.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/22.
//

import Foundation
import UIKit



public extension UIView {
    
    /// 链式 设置 view 背景色
    /// - Parameter color: 背景色
    /// - Returns: self
    @discardableResult func ag_ViewBgColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }
    
    
    /// 链式 设置 view 填充模式
    /// - Parameter mode: 填充模式
    /// - Returns: self
    @discardableResult func ag_ContentMode(_ mode: UIView.ContentMode) -> Self {
        self.contentMode = mode
        return self
    }
    
    /// 链式 设置 view 隐藏
    /// - Parameter isHidden: bool
    /// - Returns: self
    @discardableResult func ag_Hidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }
    
    /// 链式 设置 view 透明度
    /// - Parameter alpha: 透明度
    /// - Returns: self
    @discardableResult func ag_Alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }
    
    
    /// 链式 设置 view 圆角
    /// - Parameter radius: 圆角数值
    /// - Returns: self
    @discardableResult func ag_ClipsCornerRadius(_ radius: Float) -> Self {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(radius)
        return self
    }

}

public extension UIView {
    
    /// 视图的中心点坐标
    var ag_BoundsCenter:CGPoint {
        return CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
    }
    
    /// 生成当前 view 的截图
    /// - Parameter screenScale: 控制图片分辨率(x1~x3), 大图时建议设置为1, 否则图片物理内存很大
    /// - Returns: UIImage
    func  ag_SnapShotView(screenScale: CGFloat = UIScreen.main.scale)  -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, screenScale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil  }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

public extension UIView {
    
    /// 给 UIview 添加默认的点击手势,,只有使用这个方法的时候 才会自动打开用户交互
    /// - Parameter tapAction: 点击回调
    func ag_AddTapGestuer(_ tapAction:@escaping () -> Void) {
        let tap = UITapGestureRecognizer(actionClosures: tapAction)
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    ///返回该view所在VC,方便埋点查找
    func ag_SuperViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
}

// MARK: -----//// 动画 \\\\-----
public extension UIView {
    
    /// 拓展动画
    func ag_FadeShowAddToSuper(_ view: UIView)  {
        view.addSubview(self)
        self.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    /// 拓展动画
    func ag_FadeRemoveFromSuper(){
        self.alpha = 1
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        } completion: { _  in
            self.removeFromSuperview()
        }

    }
    
    /// 拓展动画
    func ag_ShakeAnimation(_ duration: TimeInterval = 0.8)  {
        self.layer.removeAllAnimations()
        
        let center  = self.center
        let shakeXLeft = center.x - 5
        let shakeXRight = center.x + 5
        let shakeAnimate = QuartzCore.CAKeyframeAnimation(keyPath: "position.x")
        shakeAnimate.duration = duration
        shakeAnimate.values = [center.x,shakeXLeft,shakeXRight,shakeXLeft,shakeXRight,shakeXLeft,shakeXRight,shakeXLeft,shakeXRight,center.x]
        /// 主线程刷新
        DispatchQueue.main.async {
            self.layer.add(shakeAnimate, forKey: "__shake__")
        }
    }
    
    /// 拓展动画
    func ag_BounceAnimation(_ duration: TimeInterval = 0.8)  {
        self.layer.removeAllAnimations()
        
        let time_1 = QuartzCore.CAMediaTimingFunction(controlPoints: 0.215, 0.610, 0.355, 1)
        let time_2 = QuartzCore.CAMediaTimingFunction(controlPoints: 0.755, 0.050, 0.855, 0.060)

        let y = self.center.y
        let value_0 = y
        let value_1 = y - 15
        let value_2 = y - 8
        let value_3 = y - 2

        let bonceAni = QuartzCore.CAKeyframeAnimation(keyPath: "position.y")
        bonceAni.duration = duration
        bonceAni.values = [value_0, value_1, value_1, value_0, value_2, value_0, value_3]
        bonceAni.keyTimes = [0.2, 0.4, 0.43, 0.53, 0.7, 0.8, 0.9]
        bonceAni.timingFunctions = [time_1, time_2, time_2, time_1, time_2, time_1, time_1, time_2]
        DispatchQueue.main.async {
            self.layer.add(bonceAni, forKey: "__bonce__")
        }
    }
    
    /// 拓展动画
    func ag_SwingAnimtion(_ duration: TimeInterval = 0.8) {
        self.layer.removeAllAnimations()

        let rotateF = 15 * Double.pi / 180.0
        let rotateS = 10 * Double.pi / 180.0
        let rotateT = 5 * Double.pi / 180.0

        let swingAni = QuartzCore.CAKeyframeAnimation(keyPath: "transform")
        swingAni.duration = duration
        swingAni.values = [CATransform3DRotate(CATransform3DIdentity, 0, 0, 0, 0),
                           CATransform3DRotate(CATransform3DIdentity, rotateF, 0, 0, 1),
                           CATransform3DRotate(CATransform3DIdentity, -rotateS, 0, 0, 1),
                           CATransform3DRotate(CATransform3DIdentity, rotateT, 0, 0, 1),
                           CATransform3DRotate(CATransform3DIdentity, -rotateT, 0, 0, 1),
                           CATransform3DRotate(CATransform3DIdentity, 0, 0, 0, 1)]
        DispatchQueue.main.async {
            self.layer.add(swingAni, forKey: "__swing__")
        }
    }
    
    
}

public enum GradualPoint{
    case left
    case top
    case right
    case bottom
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    
    public var point:CGPoint {
        switch self {
        case .left:         return CGPoint(x: 0.0, y: 0.5)
        case .top:          return CGPoint(x: 0.5, y: 0.0)
        case .right:        return CGPoint(x: 1.0, y: 0.5)
        case .bottom:       return CGPoint(x: 0.5, y: 1.0)
        case .topLeft:      return CGPoint(x: 0.0, y: 0.0)
        case .topRight:     return CGPoint(x: 1.0, y: 0.0)
        case .bottomLeft:   return CGPoint(x: 0.0, y: 1.0)
        case .bottomRight:  return CGPoint(x: 1.0, y: 1.0)
        }
    }
}


// MARK: -----//// 渐变色 \\\\-----
public extension UIView {
    /// 移除渐变色背景
    func ag_RemoveGradualLayer() {
        if let subs = self.layer.sublayers {
            for layer in subs {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    /// 添加背景色,主要是渐变色背景
    /// - Parameters:
    ///   - colors: 背景色数组,一个的话仅仅是设置背景色,多个的话会设置渐变色
    ///   - size: 视图大小,默认self.bounds,snap的需要注意layoutifneed
    ///   - startPoint: 渐变色起点
    ///   - endPoint: 渐变色终点
    func ag_SetGradualBackColor(_ colors: [UIColor],
                      size: CGSize? = nil,
                      startAnchor: GradualPoint = .topLeft,
                      endAnchor: GradualPoint = .bottomLeft){

        //startPoint: CGPoint = GradualPoint.topLeft.point,
        //endPoint: CGPoint = GradualPoint.bottomLeft.point
        let startPoint = startAnchor.point
        let endPoint   = endAnchor.point
        guard colors.count >= 1 else {
            return
        }
        
        ag_RemoveGradualLayer()
        
        if colors.count < 2 {
            backgroundColor = colors.first
        }else{
            
            let gradient: CAGradientLayer = colors.ag_Gradient { gradient in
                gradient.startPoint = startPoint
                gradient.endPoint = endPoint
                return gradient
            }
            
            gradient.drawsAsynchronously = true
            layer.insertSublayer(gradient, at: 0)
            if let s = size{
                gradient.frame = .init(x: 0, y: 0, width: s.width, height: s.height)
            }else{
              gradient.frame = self.bounds
            }
        }
    }
    
}
