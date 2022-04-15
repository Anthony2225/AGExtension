//
//  AG_Enhance.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/25.
//

import Foundation
import UIKit


extension UIScreen {
    
    /// 屏幕高度
    static var ag_ScreenH: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// 屏幕宽度
    static var ag_ScreenW: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// 屏幕尺寸
    static var ag_ScreenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    /// 信号栏高度
    static var ag_StatusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return ag_GetMainWindow()?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }

    }
    
    /// 主窗口
    public static func ag_GetMainWindow() -> UIWindow? {
        
        if #available(iOS 13.0, *) {
            let winScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            return winScene?.windows.first
        }else{
            return UIApplication.shared.keyWindow
        }
    }
    
    /// 导航栏高度 实时获取,可获取不同分辨率手机横竖屏切换后的实时高度变化
    static var ag_NavH: CGFloat {
        return UINavigationController().navigationBar.frame.size.height
    }
    
    /// 刘海屏 下方安全高度
    static var ag_SafeBottomHeight: CGFloat {
        return ag_StatusBarHeight > 20 ? 34 : 0
    }
    
    /// 导航栏 加 信号栏高度
    static var ag_TopH: CGFloat {
        return ag_NavH + ag_StatusBarHeight
    }
    
    /// tabbar 高度 实时获取,可获取不同分辨率手机横竖屏切换后的实时高度变化
    static var ag_TabbarH: CGFloat {
        return UITabBarController().tabBar.frame.size.height
    }
    
    /// tabbar 加 底部安全高度
    static var ag_BottomH: CGFloat {
        return ag_TabbarH + ag_SafeBottomHeight
    }
}
