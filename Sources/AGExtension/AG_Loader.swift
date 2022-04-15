//
//  AG_Loader.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/23.
//

import Foundation
import UIKit

// MARK: ===================================工具类:用于加载当前命名空间的资源文件=========================================

extension Bundle {
    #if !ENABLE_SPM
        private class _BundleClass { }
    #endif

    static var current: Bundle {
        #if ENABLE_SPM
            return Bundle.module
        #else
            return Bundle(for: _BundleClass.self)
        #endif
    }
}

/// 加载本地资源的 image  color
public struct AGLoader{
    
    static var bundle: Bundle = {
        let path = Bundle.current.path(forResource: "AGWheel", ofType: "bundle", inDirectory: nil)
        let bundle = Bundle(path: path ?? "")
        return bundle ?? Bundle.current
    }()
    
    /// 用图片名字 加载本地 bundle 里的图片
    /// - Parameter named: 图片名字
    /// - Returns: 图片
    public static func image(_ named: String) -> UIImage {
        guard let image = UIImage(named: named, in: bundle, compatibleWith: nil) else {
            let image = UIImage(named: named)
            return image ?? UIImage()
        }
        return image
    }
    
    /// 用颜色名字 加载 bundle 里存储的 图片
    /// - Parameter named: 颜色名字
    /// - Returns: UIcolor
    public static func color(_ named: String) -> UIColor {
        guard let color = UIColor(named: named, in: bundle, compatibleWith: nil) else {
            return UIColor(named: named) ?? UIColor.clear
        }
        return color
    }
    
    
}
