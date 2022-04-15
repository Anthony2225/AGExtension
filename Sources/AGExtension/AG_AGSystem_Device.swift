//
//  AG_AGSystem_Device.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/25.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import SystemConfiguration

extension AgSystem {
    
    // MARK: ===================================工具类: 设备=========================================
    /// 设备信息
    public struct Device {
        
        
        
        
    }
    
    
    
    // MARK: ===================================工具类:本地化 信息=========================================

    /// 本地信息
    public struct Locale{
        
        // The current language of the system.
        /// 系统的当前语言
        public static var currentLanguage: String? {
            
            if let languageCode = Foundation.Locale.current.languageCode {
                return languageCode
            }
            
            return nil
        }
        
        // The current Time Zone as TimeZone object.
        // 当前时区 对象
        public static var currentTimeZone: TimeZone {
            
            return TimeZone.current
        }
        
        // The current Time Zone identifier.
        /// 当前时区标识符
        public static var currentTimeZoneName: String {
            
            return TimeZone.current.identifier
        }
        
        
        // The current country.
        /// 当前国家/地区
        public static var currentCountry: String? {
            
            if let regionCode = Foundation.Locale.current.regionCode {
                return regionCode
            }
            
            return nil
        }
        
        // The current currency.
        /// 当前货币
        public static var currentCurrency: String? {
             
            if let currencyCode = Foundation.Locale.current.currencyCode {
                return currencyCode
            }
            
            return nil
        }
        
        
        // The current currency symbol.
        /// 当前货币符号
        public static var currentCurrencySymbol: String? {
            
            if let currencySymbol = Foundation.Locale.current.currencySymbol {
                return currencySymbol
            }
            
            return nil
        }
        
        
        // Check if the system is using the metric system.
        /// 检查系统是否正在使用公制系统
        public static var usesMetricSystem: Bool {
            
            return Foundation.Locale.current.usesMetricSystem
        }
        
        /// The decimal separator
        /// 返回当前语言的 小数点
        public static var decimalSeparator: String? {
            
            if let decimalSeparator = Foundation.Locale.current.decimalSeparator {
                return decimalSeparator
            }
            
            return nil
        }
    }
    
    
    // MARK: ===================================工具类: WIFI 信息=========================================
    @available(iOS,deprecated: 13.0,message: "废弃了,暂时未找到其他关于WiFi 的简单拓展")
    public struct WIFI {
        
        @available(iOS,deprecated: 13.0,message: "不再可能使用CNCopy支持的接口获取SSID信息")
        public static var SSID: String {
            
            var  wifiName: String = ""
            if let interfaces = CNCopySupportedInterfaces() {
                for i in 0..<CFArrayGetCount(interfaces) {
                    let  interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                    let  rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                    let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                    if unsafeInterfaceData != nil  {
                        let inerfaceData = unsafeInterfaceData as Dictionary?
                        for dicData in inerfaceData!  {
                            if dicData.key as! String == "SSID" {
                                wifiName = dicData.value as! String
                            }
                        }
                    }
                    
                
                }
            }
            
            return wifiName
            
        }
        
    }
    
    
}
