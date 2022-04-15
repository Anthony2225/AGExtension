//
//  AGCachesImage.swift
//  AGWheel
//
//  Created by Anthony on 2022/4/12.
//

import UIKit

/// 图片缓存路径
let cachesImagePath = "/Documents/images/"

struct AGCachesImage {
    
    static let  shared: AGCachesImage = AGCachesImage()
    
    
    ///  缓存图片并写入
    /// - Parameter imgUrl: 图片地址
    public func downloadCachesImage(_ imgUrl: String){
        DispatchQueue.global().async {
            guard imgUrl.count > 0 else {return}
            let data = self .downloadImage(imgUrl)
            guard data != nil else{return}
            self.writeImageData(data!, imgUrl)
        }

    }
    
    
    /// 下载图片
    /// - Parameter imageUrl: 图片地址
    /// - Returns: 图片 data
    public func downloadImage(_ imageUrl: String)  -> Data? {
        
        guard imageUrl.count > 0 else {return nil}
        if FileManager.default.fileExists(atPath: self.createPath() + imageUrl.replacingOccurrences(of: "/", with: "")) {
            debugPrint("图片已存在相同的")
            return nil
        }
        guard let url = URL(string: imageUrl) else {
            return nil
        }
        
        
        do {
            let imageData = try Data(contentsOf: url)
            return imageData
            
        }catch {
            debugPrint(error)
            return nil
        }
        
    }
    
    
    /// 根据图片地址获取本地图片
    /// - Parameter imageUrl: 图片地址
    /// - Returns: image
    public func readCachesImage(imageUrl: String)    -> UIImage? {
        let path = self.createPath() + imageUrl.replacingOccurrences(of: "/", with: "")
        if FileManager.default.fileExists(atPath: path) {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            return UIImage(data: data)
        }
        return nil
    }
    
    public func readCachesData(imageUrl: String)   -> Data? {
        let path = self.createPath() + imageUrl.replacingOccurrences(of: "/", with: "")
        if FileManager.default.fileExists(atPath: path) {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            return data
        }
        return nil
    }
    
    /// 把图片写入缓存
    /// - Parameters:
    ///   - data: 图片data
    ///   - key: 写入名称
    /// - Returns: 写入结果
    @discardableResult
    public func writeImageData(_ data: Data, _ key: String)  -> (isSuccess: Bool, error: String){
        var state: Bool = false
        var err: String = ""
        DispatchQueue.global().async {
            let path = self.createPath() + key.replacingOccurrences(of: "/", with: "")
            do {
                try data.write(to: URL(fileURLWithPath: path))
                state = true
                err = "成功"
            }catch {
                state = false
                err = "写入失败"
                print(error )
            }
        }
        return (state,err)
        
    }
    
    public func deleteLocal(key: String){
        let path = key.replacingOccurrences(of: "/", with: "")
        removeItem(atPath: self.createPath(), key: path)
        
    }
    
    
    private func removeItem(atPath: String, key: String) {
        if FileManager.default.fileExists(atPath: atPath + key) {
            try! FileManager.default.removeItem(atPath: atPath + key)
        }
    }
    
    
    /// 拼接 图片缓存路径 并创建路径
    /// - Returns: 图片缓存路径
    private func  createPath() -> String {
        let newPath = NSHomeDirectory() + cachesImagePath
        
        if  !FileManager.default.fileExists(atPath: newPath) {
            print(newPath)
            try! FileManager.default.createDirectory(atPath: newPath, withIntermediateDirectories: true, attributes: nil )
            
        }
        return newPath
    }
    
    
    
    
}
