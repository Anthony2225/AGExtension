//
//  AG_AGSyetem_Audio.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/24.
//

import Foundation
import AVFoundation
import UIKit
import CoreTelephony

// MARK: ===================================工具类: 系统音量相关=========================================

extension AgSystem {
    
    public struct Audio{
        
        public static var currentAudioOutputColune: Double? {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                let volume = audioSession.outputVolume
                return Double(volume)
            }catch{
                print("❌AG_AGSyetem_Audio---Error: Failed to activate audio session ❌")
                return nil
            }
        }
        
        
        /// The value is true when another application with a non-mixable audio session is playing audio
        /// 当具有不可混音音频会话的另一个应用程序正在播放音频时，该值为 true
        public static var secondryAudioShouldBeSilencedHint: Bool {
            
            return AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
        }
    }
}

// MARK: ===================================工具类:电量相关 =========================================

extension AgSystem {
    
    
    
    /// Battery information 电池信息
    public struct Battery {
        
        private static var device: UIDevice{
            get {
                let device = UIDevice.current
                device.isBatteryMonitoringEnabled = true
                
                return device
            }
        }
        
        // The current level of the battery
        /// 电池的当前电量
        public static var level: Float? {
            
            let batteryCharge = device.batteryLevel
            if batteryCharge > 0 {
                return batteryCharge * 100
            }else{
                return nil
            }
        }
        
        
        // The current battery state of the device
        /// 设备的当前电池状态
        public static var state: BateryState {
            
            switch device.batteryState{
            case .unknown:
                return BateryState.unknown
            case .unplugged:
                return BateryState.unplugged
            case .charging:
                return BateryState.charging
            case .full:
                return BateryState.full
            }
        }
        
        
    }
}


// MARK: ===================================工具类:网络运营商相关 =========================================

extension AgSystem {
    
    public struct Carrier {
        
        
        private static var carrier:CTCarrier? {
            get {
                if #available(iOS 12.0, *) {
                    let dic:Dictionary = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders!
                    let allValue = dic.values.filter{$0.carrierName?.count ?? 0 > 0}
                    return allValue.count > 0 ? allValue.first : nil
                }else{
                    return CTTelephonyNetworkInfo().subscriberCellularProvider!
                }

                
            }
        }
        
        
        // The name of the carrier or nil if not available.
        /// 运营商名字,,如果不可用 为 nil
        public static var name: String? {
            
            if carrier != nil {
                return carrier?.carrierName
            }
            
            return nil
        }
        
        // The carrier ISO code or nil if not available.
        /// 运营商 ISO 代码或 nil（如果不可用）。
        public static var ISOCountryCode: String? {
            
            if carrier != nil  {
                return carrier?.isoCountryCode
            }
            return nil
        }
        
        // The carrier mobile country code or nil if not available
        /// 运营商移动国家/地区代码或 nil （如果不可用）。
        public static var mobileCountryCode: String? {
            
            if carrier != nil  {
                return carrier?.mobileCountryCode
            }
            
            return nil
        }
        
        
        // The carrier network country code or nil if not available
        /// 运营商网络国家/地区代码或无（如果不可用）
        @available(*, deprecated, message: " AGSystem:--Use mobileNetworkCode instead")
        public static var networkCountryCode: String? {
            
            if carrier != nil  {
                return carrier?.mobileNetworkCode
            }
            
            return nil
        }
        
        
        // Check if the carrier allows Voip.
        /// 检查运营商是否允许Voip。
        public static var isVoipAllowed: Bool? {
            
            if carrier != nil  {
                return carrier?.allowsVOIP
            }
            
            return nil
        }
        
    }
}
