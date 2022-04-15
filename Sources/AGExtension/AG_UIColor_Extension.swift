//
//  AGColor.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/18.
//

// MARK: ===================================拓展工具:UIColor 相关功能的补充拓展=========================================

#if canImport(UIKit)
import UIKit
public extension UIColor {
    //可以 直接打点调用
    static let themeColor = UIColor(hex:"F64C0F")
    // 在 Assets 里面配置可以直接 切换暗黑模式
    static let baseBgColor = AGLoader.color("bgColor")
    static let baseLineColor = AGLoader.color("baseLineColor")
}

public extension UIColor{
    
    
    /// UIColor 便利 构造器
    /// - Parameter string: 十六进制
    convenience init(hex string :String){
        // 如果带#号就去掉# 不带就直接拿
        var hex = string.hasPrefix("#") ? String(string.dropFirst()) : string
        guard hex.count == 3 || hex.count == 6 else {
            self.init(white: 1.0, alpha: 0.0)
            return
        }
        if hex.count == 3 {
            for (index,char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }
        
        guard let intCode = Int(hex,radix: 16) else {
            self.init(white: 1.0, alpha: 0.0)
            return
            
        }
        
        self.init(
            red:   CGFloat((intCode >> 16) & 0xFF) / 255.0,
            green: CGFloat((intCode >> 8) & 0xFF) / 255.0,
            blue:  CGFloat((intCode) & 0xFF) / 255.0, alpha: 1.0
        )
    }
    
    
    /// 根据饱和度调整颜色
    /// - Parameter minSaturation: 最小饱和度值
    /// - Returns: 调整后的颜色
    func color(minSaturation: CGFloat) -> UIColor {
      var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
      getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
      
      return saturation < minSaturation
        ? UIColor(hue: hue, saturation: minSaturation, brightness: brightness, alpha: alpha)
        : self
    }

    
    /// 更改颜色 alpha 的快捷方法
    /// - Parameter value: alpha 值
    /// - Returns: alpha 调整后的颜色
    func alpha(_ value:CGFloat) -> UIColor {
        return withAlphaComponent( value)
    }
    
    /// 随机颜色
    static var  randomColor:UIColor {
        get {
            let r = CGFloat(arc4random() % 256) / 255
            let g = CGFloat(arc4random() % 256) / 255
            let b = CGFloat(arc4random() % 256) / 255
            return UIColor(red: r, green: g, blue: b, alpha: 1)
        }
    }
    
}

// MARK: -----//// Helpers \\\\-----
public extension UIColor {
    
    /// 返回颜色的 16进制 字符串
    /// - Returns:  颜色 1 进制字符串
    ///  hashPrefix:Bool   默认 true ,带# 号前缀,,否则不带#号前缀
    func hexString (hashPrefix:Bool = true) -> String {
        var (r,g,b,a):(CGFloat,CGFloat,CGFloat,CGFloat) = (0.0,0.0,0.0,0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let prefix = hashPrefix ? "#" : ""
        
        return String(format: "\(prefix)%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
    
    /// 返回颜色的 RGB 数组
    /// - Returns: RGB 数组 [CGFloat]
    func ag_RgbComponents() -> [CGFloat] {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return[r,g,b]
    }
    
    /// 判断 颜色是亮色还是暗色 可以根据颜色 设置图层上文字颜色,防止看不到文字
    var ag_IsDark: Bool {
      let RGB = ag_RgbComponents()
      return (0.2126 * RGB[0] + 0.7152 * RGB[1] + 0.0722 * RGB[2]) < 0.5
    }
    
    /// 判断颜色是不是 黑色 或 白色
    var ag_IsBlackOrWhite: Bool {
      let RGB = ag_RgbComponents()
      return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91) || (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
    }
    
    /// 判断颜色是不是 黑色
    var ag_IsBlack: Bool {
      let RGB = ag_RgbComponents()
      return (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
    }
    
    /// 判断颜色是不是 白色
    var ag_IsWhite: Bool {
      let RGB = ag_RgbComponents()
      return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91)
    }
    
    /// 作用未知    判断颜色是不是清晰
    /// - Parameter color:
    /// - Returns:
    func ag_IsDistinct(from color: UIColor) -> Bool {
      let bg = ag_RgbComponents()
      let fg = color.ag_RgbComponents()
      let threshold: CGFloat = 0.25
      var result = false
      
      if abs(bg[0] - fg[0]) > threshold || abs(bg[1] - fg[1]) > threshold || abs(bg[2] - fg[2]) > threshold {
          if abs(bg[0] - bg[1]) < 0.03 && abs(bg[0] - bg[2]) < 0.03 {
              if abs(fg[0] - fg[1]) < 0.03 && abs(fg[0] - fg[2]) < 0.03 {
            result = false
          }
        }
        result = true
      }
      
      return result
    }
    
    /// 作用未知
    /// - Parameter color: <#color description#>
    /// - Returns: <#description#>
    func ag_IsContrasting(with color: UIColor) -> Bool {
      let bg = ag_RgbComponents()
      let fg = color.ag_RgbComponents()
      
      let bgLum = 0.2126 * bg[0] + 0.7152 * bg[1] + 0.0722 * bg[2]
      let fgLum = 0.2126 * fg[0] + 0.7152 * fg[1] + 0.0722 * fg[2]
      let contrast = bgLum > fgLum
        ? (bgLum + 0.05) / (fgLum + 0.05)
        : (fgLum + 0.05) / (bgLum + 0.05)
      
      return 1.6 < contrast
    }
}


// MARK: - Gradient

public extension Array where Element : UIColor {
    
    /// 未知
    /// - Parameter transform: <#transform description#>
    /// - Returns: <#description#>
  func ag_Gradient(_ transform: ((_ gradient: inout CAGradientLayer) -> CAGradientLayer)? = nil) -> CAGradientLayer {
    var gradient = CAGradientLayer()
    gradient.colors = self.map { $0.cgColor }
    
    if let transform = transform {
      gradient = transform(&gradient)
    }
    
    return gradient
  }
}



// MARK: - Components

public extension UIColor {
    
    /// 颜色 rgb值得 r
  var redComponent: CGFloat {
    var red: CGFloat = 0
    getRed(&red, green: nil , blue: nil, alpha: nil)
    return red
  }

    /// 颜色 rgb值得 g
  var greenComponent: CGFloat {
    var green: CGFloat = 0
    getRed(nil, green: &green , blue: nil, alpha: nil)
    return green
  }

    /// 颜色 rgb值得 b
  var blueComponent: CGFloat {
    var blue: CGFloat = 0
    getRed(nil, green: nil , blue: &blue, alpha: nil)
    return blue
  }

    /// 颜色 的 alpha值
  var alphaComponent: CGFloat {
    var alpha: CGFloat = 0
    getRed(nil, green: nil , blue: nil, alpha: &alpha)
    return alpha
  }
    
    /// 色度
  var hueComponent: CGFloat {
    var hue: CGFloat = 0
    getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
    return hue
  }
    
    /// 饱和度
  var saturationComponent: CGFloat {
    var saturation: CGFloat = 0
    getHue(nil, saturation: &saturation, brightness: nil, alpha: nil)
    return saturation
  }
    
    /// 亮度
  var brightnessComponent: CGFloat {
    var brightness: CGFloat = 0
    getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
    return brightness
  }
}


// MARK: - Blending

public extension UIColor {
  
  /**adds hue, saturation, and brightness to the HSB components of this color (self)*/
  func add(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) -> UIColor {
    var (oldHue, oldSat, oldBright, oldAlpha) : (CGFloat, CGFloat, CGFloat, CGFloat) = (0,0,0,0)
    getHue(&oldHue, saturation: &oldSat, brightness: &oldBright, alpha: &oldAlpha)
    
    // make sure new values doesn't overflow
    var newHue = oldHue + hue
    while newHue < 0.0 { newHue += 1.0 }
    while newHue > 1.0 { newHue -= 1.0 }
    
    let newBright: CGFloat = max(min(oldBright + brightness, 1.0), 0)
    let newSat: CGFloat = max(min(oldSat + saturation, 1.0), 0)
    let newAlpha: CGFloat = max(min(oldAlpha + alpha, 1.0), 0)
    
    return UIColor(hue: newHue, saturation: newSat, brightness: newBright, alpha: newAlpha)
  }
  
  /**adds red, green, and blue to the RGB components of this color (self)*/
  func add(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
    var (oldRed, oldGreen, oldBlue, oldAlpha) : (CGFloat, CGFloat, CGFloat, CGFloat) = (0,0,0,0)
    getRed(&oldRed, green: &oldGreen, blue: &oldBlue, alpha: &oldAlpha)
    // make sure new values doesn't overflow
    let newRed: CGFloat = max(min(oldRed + red, 1.0), 0)
    let newGreen: CGFloat = max(min(oldGreen + green, 1.0), 0)
    let newBlue: CGFloat = max(min(oldBlue + blue, 1.0), 0)
    let newAlpha: CGFloat = max(min(oldAlpha + alpha, 1.0), 0)
    return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
  }
  
  func add(hsb color: UIColor) -> UIColor {
    var (h,s,b,a) : (CGFloat, CGFloat, CGFloat, CGFloat) = (0,0,0,0)
    color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    return self.add(hue: h, saturation: s, brightness: b, alpha: 0)
  }
  
  func add(rgb color: UIColor) -> UIColor {
    return self.add(red: color.redComponent, green: color.greenComponent, blue: color.blueComponent, alpha: 0)
  }
  
  func add(hsba color: UIColor) -> UIColor {
    var (h,s,b,a) : (CGFloat, CGFloat, CGFloat, CGFloat) = (0,0,0,0)
    color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    return self.add(hue: h, saturation: s, brightness: b, alpha: a)
  }
  
  /**adds the rgb components of two colors*/
  func add(rgba color: UIColor) -> UIColor {
    return self.add(red: color.redComponent, green: color.greenComponent, blue: color.blueComponent, alpha: color.alphaComponent)
  }
}
#endif
