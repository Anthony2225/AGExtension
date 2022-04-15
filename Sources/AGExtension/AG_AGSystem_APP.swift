//
//  AG_AGSystem_APP.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/24.
//

import Foundation
import UIKit

extension AgSystem {
    
    // MARK: ===================================工具类:APP 信息=========================================
    /// app 信息
    public struct APPInfo{
        
        /// 项目名称
        public static var appName: String? {
            return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        }
        
        /// app 显示的名字
        public static var displayName: String? {
            return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
        }
        
        /// app 的bundleid
        public static var bundleID: String? {
            return Bundle.main.bundleIdentifier
        }
        
        /// build 构架版本号
        public static var buildNumber: String? {
            return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
        }
    }
    
    
    
    // MARK: ===================================工具类:APP 版本=========================================

    /// APP 版本相关
    public struct AppVersion {
        
        /// The current app version. 当前应用版本
        public static var version: String {
            
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        }
        
        /// The build number.构建版本
        public static var build:String {
            
            return Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        }
        
        /// 带有内部版本的完整应用程序版本  (i.e. : "2.1.3 (343)"). The complete app version with build number
        public static var completeAppVersion: String {
            
            return "\(AppVersion.version) (\(AppVersion.build))"
        }
        
        /// 剪贴板的当前内容（仅字符串） The current content of the clipboard (only string).
        public static var clipboardString: String? {
            
            return UIPasteboard.general.string
        }
    }
    
    // MARK: ===================================工具类:系统版本 =========================================

    /// 系统版本
    public struct SystemVersion {
        /// 主版本号
        public let major: Int
        /// 次要版本号
        public let minor: Int
        /// 补丁版本
        public let patch: Int
        
        public let versionString: String
        /// 初始化系统版本  e.g.  AgSystem.Version.init()
        public init() {
            major = ProcessInfo.processInfo.operatingSystemVersion.majorVersion
            minor = ProcessInfo.processInfo.operatingSystemVersion.minorVersion
            patch = ProcessInfo.processInfo.operatingSystemVersion.patchVersion
            versionString = "\(major).\(minor).\(patch)"

        }
        
        /// 使用自定义的版本号初始化
        /// - Parameters:
        ///   - major: 版本号
        ///   - minor: 版本号
        ///   - patch: 版本号
        public init(_ major: Int, _ minor: Int, _ patch: Int) {
            self.major = major
            self.minor = minor
            self.patch = patch
            versionString = "\(major).\(minor).\(patch)"

        }
        
        
        /// 把 app版本初始化成和系统版本一样的  e.g.  AgSystem.Version.init(AgSystem.Application.version)
        public init(_ appVersion: String){
            guard appVersion.contains(".") else { fatalError("版本错误!!!")}
            let components = appVersion.ag_ToArray(separator: ".")
            major = components.count > 0 ? Int(components[0])! : 0
            minor = components.count > 1 ? Int(components[1])! : 0
            patch = components.count > 2 ? Int(components[2])! : 0
            versionString = "\(major).\(minor).\(patch)"

        }

    }
}


extension AgSystem.SystemVersion : Comparable {
    
    
    
    fileprivate static func compare<T: Comparable>(lhs: T, rhs: T) -> ComparisonResult {
        if lhs < rhs {
            return .orderedAscending
        } else if lhs > rhs {
            return .orderedDescending
        } else {
            return .orderedSame
        }
    }
    
    
    /// 系统版本号比对
    /// - Parameters:
    ///   - lhs: 左
    ///   - rhs: 右
    /// - Returns: true/false
    public static func == (lhs: AgSystem.SystemVersion, rhs: AgSystem.SystemVersion) -> Bool {
        return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch
    }
    /// 系统版本号比对
    /// - Parameters:
    ///   - lhs: 左
    ///   - rhs: 右
    /// - Returns: true/false
    public static func < (lhs: AgSystem.SystemVersion, rhs: AgSystem.SystemVersion) -> Bool {
        let majorComparison = AgSystem.SystemVersion.compare(lhs: lhs.major, rhs: rhs.major)
        if majorComparison != .orderedSame {
            return majorComparison == .orderedAscending
        }

        let minorComparison = AgSystem.SystemVersion.compare(lhs: lhs.minor, rhs: rhs.minor)
        if minorComparison != .orderedSame {
            return minorComparison == .orderedAscending
        }

        let patchComparison = AgSystem.SystemVersion.compare(lhs: lhs.patch, rhs: rhs.patch)
        if patchComparison != .orderedSame {
            return patchComparison == .orderedAscending
        }

        return false
    }
}
