//
//  AGImage+hue.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/21.
//

// MARK: ===================================拓展工具:UIImage 功能的补充和拓展=========================================


#if canImport(UIKit)
import UIKit
import CommonCrypto

class CountedColor {
  let color: UIColor
  let count: Int
  
  init(color: UIColor, count: Int) {
    self.color = color
    self.count = count
  }
}

// MARK:  UIimage about color

extension UIImage {
    
    /// - Parameters:通过颜色生成图片
    ///   - color: 颜色
    ///   - size: 图片尺寸
    /// - Returns: UIimage
    public class func ag_buildImageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return UIImage()
        }
        context.setFillColor(color.cgColor);
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height));
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img ?? UIImage()
    }
    
    
    fileprivate func resize(to newSize: CGSize) -> UIImage {
      UIGraphicsBeginImageContextWithOptions(newSize, false, 2)
      draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
      let result = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      return result!
    }
    
    /// 取图片色系
    /// - Parameter scaleDownSize: 缩小比例
    /// - Returns: 元组 (background 背景色, primary主色调 secondary次要颜色 detail内容颜色)
    public func ag_Colors(scaleDownSize: CGSize? = nil) -> (background: UIColor, primary: UIColor, secondary: UIColor, detail: UIColor) {
      let cgImage: CGImage
      
      if let scaleDownSize = scaleDownSize {
        cgImage = resize(to: scaleDownSize).cgImage!
      } else {
        let ratio = size.width / size.height
        let r_width: CGFloat = 250
        cgImage = resize(to: CGSize(width: r_width, height: r_width / ratio)).cgImage!
      }
      
      let width = cgImage.width
      let height = cgImage.height
      let bytesPerPixel = 4
      let bytesPerRow = width * bytesPerPixel
      let bitsPerComponent = 8
      let randomColorsThreshold = Int(CGFloat(height) * 0.01)
      let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
      let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      let raw = malloc(bytesPerRow * height)
      let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
      let context = CGContext(data: raw, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
      context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
      let data = UnsafePointer<UInt8>(context?.data?.assumingMemoryBound(to: UInt8.self))
      let imageBackgroundColors = NSCountedSet(capacity: height)
      let imageColors = NSCountedSet(capacity: width * height)
      
      let sortComparator: (CountedColor, CountedColor) -> Bool = { (a, b) -> Bool in
        return a.count <= b.count
      }
      
      for x in 0..<width {
        for y in 0..<height {
          let pixel = ((width * y) + x) * bytesPerPixel
          let color = UIColor(
            red:   CGFloat((data?[pixel+1])!) / 255,
            green: CGFloat((data?[pixel+2])!) / 255,
            blue:  CGFloat((data?[pixel+3])!) / 255,
            alpha: 1
          )
          
          if x >= 5 && x <= 10 {
            imageBackgroundColors.add(color)
          }
          
          imageColors.add(color)
        }
      }
      
      var sortedColors = [CountedColor]()
      
      for color in imageBackgroundColors {
        guard let color = color as? UIColor else { continue }
        
        let colorCount = imageBackgroundColors.count(for: color)
        
        if randomColorsThreshold <= colorCount  {
          sortedColors.append(CountedColor(color: color, count: colorCount))
        }
      }
      
      sortedColors.sort(by: sortComparator)
      
      var proposedEdgeColor = CountedColor(color: blackColor, count: 1)
      
      if let first = sortedColors.first { proposedEdgeColor = first }
      
      if proposedEdgeColor.color.ag_IsBlackOrWhite && !sortedColors.isEmpty {
        for countedColor in sortedColors where CGFloat(countedColor.count / proposedEdgeColor.count) > 0.3 {
          if !countedColor.color.ag_IsBlackOrWhite {
            proposedEdgeColor = countedColor
            break
          }
        }
      }
      
      let imageBackgroundColor = proposedEdgeColor.color
      let isDarkBackgound = imageBackgroundColor.ag_IsDark
      
      sortedColors.removeAll()
      
      for imageColor in imageColors {
        guard let imageColor = imageColor as? UIColor else { continue }
        
        let color = imageColor.color(minSaturation: 0.15)
        
        if color.ag_IsDark == !isDarkBackgound {
          let colorCount = imageColors.count(for: color)
          sortedColors.append(CountedColor(color: color, count: colorCount))
        }
      }
      
      sortedColors.sort(by: sortComparator)
      
      var primaryColor, secondaryColor, detailColor: UIColor?
      
      for countedColor in sortedColors {
        let color = countedColor.color
        
        if primaryColor == nil &&
          color.ag_IsContrasting(with: imageBackgroundColor) {
          primaryColor = color
        } else if secondaryColor == nil &&
          primaryColor != nil &&
          primaryColor!.ag_IsDistinct(from: color) &&
          color.ag_IsContrasting(with: imageBackgroundColor) {
          secondaryColor = color
        } else if secondaryColor != nil &&
          (secondaryColor!.ag_IsDistinct(from: color) &&
            primaryColor!.ag_IsDistinct(from: color) &&
            color.ag_IsContrasting(with: imageBackgroundColor)) {
          detailColor = color
          break
        }
      }
      
      free(raw)
      
      return (
        imageBackgroundColor,
        primaryColor   ?? (isDarkBackgound ? whiteColor : blackColor),
        secondaryColor ?? (isDarkBackgound ? whiteColor : blackColor),
        detailColor    ?? (isDarkBackgound ? whiteColor : blackColor))
    }
    
    /// 计算指定坐标的颜色 取图片上一点颜色
    /// - Parameters:
    ///   - point: 坐标点
    ///   - completion: 指定坐标的颜色
    public func ag_Color(at point: CGPoint, completion: @escaping (UIColor?) -> Void) {
      let size = self.size
      let cgImage = self.cgImage
      
      DispatchQueue.global(qos: .userInteractive).async {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let imgRef = cgImage,
          let dataProvider = imgRef.dataProvider,
          let dataCopy = dataProvider.data,
          let data = CFDataGetBytePtr(dataCopy), rect.contains(point) else {
            DispatchQueue.main.async {
              completion(nil)
            }
            return
        }
        
        let pixelInfo = (Int(size.width) * Int(point.y) + Int(point.x)) * 4
        let red = CGFloat(data[pixelInfo]) / 255.0
        let green = CGFloat(data[pixelInfo + 1]) / 255.0
        let blue = CGFloat(data[pixelInfo + 2]) / 255.0
        let alpha = CGFloat(data[pixelInfo + 3]) / 255.0
        
        DispatchQueue.main.async {
          completion(UIColor(red: red, green: green, blue: blue, alpha: alpha))
        }
      }
    }
    
    ///  压缩图片 jpeg
    /// - Parameters:
    ///   - img: 待压缩图片
    ///   - maxKBCost: 压缩后的最大值 (KB) 默认500
    ///   - maxPicelW: 分辨率宽的最大值 (保持原比例 降低分辨率, 默认856, iPhone设备max  = 428pt * 926)
    /// - Returns: data with jpeg format
    static func ag_TryCompress(_ img: UIImage, maxKBCost: Int = 500, maxPixelW: Int = 856) -> Data? {
        func __kbCost(_ byte: Int) -> Int {
            return Int(ceilf(Float(byte) / 1024))
        }
        
        func __compressPixel(_ img: UIImage, maxPixelW: Int) -> UIImage {
            let originW = Int(img.size.width*img.scale)
            let originH = Int(img.size.height*img.scale)
            
            var newImage: UIImage?
            if originW > maxPixelW {
                // 降低分辨率到允许的最大值(等比缩小)
                let newW = maxPixelW
                let newH = Int(floorf(Float(maxPixelW) / Float(originW)*Float(originH)))
                autoreleasepool {
                    UIGraphicsBeginImageContextWithOptions(CGSize(width: newW, height: newH), false, 1)
                    img.draw(in: CGRect(x: 0, y: 0, width: newW, height: newH))
                    newImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                }
            }
            return newImage ?? img
        }
        
        func __compressQuality(_ img: UIImage, bestCostKB: Int) -> Data? {
            // 二分法寻找最佳压缩质量
            var defultData, bestData: Data?
            var begin = 0
            var end = 100
            while begin + 1 < end {
                let index = (begin + end) / 2
                guard let compresData = img.jpegData(compressionQuality: CGFloat(index) / 100) else {
                    assertionFailure("compress quality Failure, please check code ...")
                    break
                }
                let compressCost = __kbCost(compresData.count)
                
                if compressCost > bestCostKB {
                    end = index
                    if defultData == nil || (compressCost < __kbCost(defultData?.count ?? 0)) {
                        defultData = compresData
                    }
                } else if compressCost < bestCostKB {
                    begin = index
                    if bestData == nil || (compressCost > __kbCost(bestData?.count ?? 0)) {
                        bestData = compresData
                    }
                } else {
                    bestData = compresData
                    break
                }
            }
            return bestData ?? defultData ?? img.jpegData(compressionQuality: 0.8)
        }
        
        // jpegData: 这个方法 quality:1 得到data.cout也许会比实际图片大
        if let imgData = img.jpegData(compressionQuality: 0.8), __kbCost(imgData.count) <= maxKBCost {
            return imgData
        }
        
        // 1. 降低分辨率到允许的最大值(等比缩小)
        let maxPixelImg = __compressPixel(img, maxPixelW: maxPixelW)
        if let finalData = maxPixelImg.jpegData(compressionQuality: 0.8),
           __kbCost(finalData.count) <= maxKBCost
        {
            return finalData
        }
    
        // 2. 二分法压缩质量
        let lowstQualityData = __compressQuality(maxPixelImg, bestCostKB: maxKBCost)
        if let data = lowstQualityData,
           __kbCost(data.count) <= maxKBCost
        {
            return data
        }
        
        // 3. 再次逐步降低分辨率
        var step3Image: UIImage!
        if let data = lowstQualityData {
            step3Image = UIImage(data: data) ?? maxPixelImg
        } else {
            step3Image = maxPixelImg
        }
        var finalData: Data?
        let distant = Float(maxPixelW) / 15
        bkTag: while true {
            finalData = step3Image.jpegData(compressionQuality: 0.8)
            if let finalData = finalData, __kbCost(finalData.count) <= maxKBCost {
                break bkTag
            }
            let imgWitdh = Float(step3Image.size.width*step3Image.scale)
            if imgWitdh < distant*5 {
                break bkTag
            }
            step3Image = __compressPixel(step3Image, maxPixelW: Int(imgWitdh - distant))
        }

        return finalData ?? lowstQualityData
    }
    
    
}


public extension UIImage {
    public var sha256: String {
        let data = Data(self.pngData()!)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_SHA256(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.reduce("") { $0 + String(format:"%02x", $1) }
    }
    
    /// 生成占位图
    /// - Parameters:
    ///   - image: 小图
    ///   - imageView: 图片视图
    /// - Returns: 图片
    public static func ag_CreatePlaceHolderImage(image: UIImage?, imageView: UIImageView) -> UIImage?{
        imageView.layoutIfNeeded()
        guard let image = image else {
            return nil
        }
        let name = image.sha256
        let imageName = "placeHolder_\(imageView.bounds.size.width)_\(imageView.bounds.size.height)_\(name).png"
        let fileManager = FileManager.default
        let path: String = NSHomeDirectory() + "/Documents/PlaceHolder/"
        let filePath = path + imageName
        if fileManager.fileExists(atPath: filePath) {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath))
            else { return nil }
            let image = UIImage(data: data)
            return image
        }
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.setFillColor(UIColor.clear.cgColor)
            ctx.fill(CGRect(origin: CGPoint.zero, size: imageView.bounds.size))
            
            let placeholderRect = CGRect(x: (imageView.bounds.size.width - image.size.width) / 2.0,
                                         y: (imageView.bounds.size.height - image.size.height) / 2.0,
                                         width: image.size.width,
                                         height: image.size.height)
            
            ctx.saveGState()
            ctx.translateBy(x: placeholderRect.origin.x, y: placeholderRect.origin.y)
            ctx.translateBy(x: 0, y: placeholderRect.size.height)
            ctx.scaleBy(x: 1.0, y: -1.0)
            ctx.translateBy(x: -placeholderRect.origin.x, y: -placeholderRect.origin.y)
            ctx.draw(image.cgImage!, in: placeholderRect, byTiling: false)
            ctx.restoreGState()
        }
        
        if let placeHolder = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            try? fileManager.createDirectory(at: URL(fileURLWithPath: path), withIntermediateDirectories: true, attributes: nil)
            fileManager.createFile(atPath: filePath, contents: placeHolder.pngData(), attributes: nil)
            return placeHolder
        }
        UIGraphicsEndImageContext()
        return nil
    }
}


#endif
