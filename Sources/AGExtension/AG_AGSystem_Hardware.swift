//
//  AG_System_Hardware.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/25.
//

import Foundation
import UIKit
import ExternalAccessory
import AVFoundation
import CoreMotion

extension AgSystem {
    
    // MARK: ===================================工具类: 屏幕相关 =========================================
    /// 屏幕
    public struct Screen{
        
        // The current brightness
        /// 当前亮度
        public static var brightness: Float {
            
            return Float(UIScreen.main.brightness)
        }
        
        // Check if the screen is being mirrored.
        /// 检查屏幕是否正在镜像
        public static var isScreenMirrored: Bool {
            
            if let _ = UIScreen.main.mirrored {
                return true
            }
            
            return false
        }
        
        // The bounding rectange of the physical screen measured in pixels.
        /// 以像素为单位测量的物理屏幕的边框。
        public static var nativeBounds: CGRect {
            
            return UIScreen.main.nativeBounds
        }
        
        // The scale of the physical screen.
        /// 物理屏幕的比例
        public static var nativeScale: Float {
            
            return Float(UIScreen.main.nativeScale)
        }
        
        // The bounds of the current main screen.
        /// 当前主屏幕的边界
        public static var bounds: CGRect {
            
            return UIScreen.main.bounds
        }
        
        // The scale of the current main screen.
        /// 当前主屏幕的比例
        public static var scale: Float {
            
            return Float(UIScreen.main.scale)
        }
        
        // The snapshot of the current view after all the updates are applied.
        /// 应用所有更新后当前视图的快照
        public static var snapshotOfCurrentView: UIView {
            
            return UIScreen.main.snapshotView(afterScreenUpdates: true)
        }
    }
    
    // MARK: ===================================工具类:配件信息 =========================================
    // 系统类库 ExternalAccessory
    /// 外接设备
    public struct Accessory {
        
        // The number of connected accessories
        /// 连接的配件数量
        public static var accessoryCount: Int {
            
            return EAAccessoryManager.shared().connectedAccessories.count
        }
        
        // The names of the attacched accessories. If no accessory is attached the array will be empty, but not nil
        /// 附件的名称。如果未连接任何附件，则阵列将为空，但不是无
        public static var connectedAccessoriesNames: [String] {
            
            var theNames: [String] = []
            
            for accessory in EAAccessoryManager.shared().connectedAccessories {
                
                theNames.append(accessory.name)
            }
            
            return theNames
        }
        
        // The accessories connected and available to use for the app as EAAccessory objects
        /// 连接并可用作 EAAccessory 对象的附件
        public static var connectedAccessories: [EAAccessory] {
            
            return EAAccessoryManager.shared().connectedAccessories
        }
        
        
        // Check if headphones are plugged in
        /// 检查耳机是否已插入
        public static var isHeadsetPluggedIn: Bool {
            // !!!: Thanks to Antonio E., this code is coming from this SO answer : http://stackoverflow.com/a/21382748/588967 . I've only translated it in Swift
            let route = AVAudioSession.sharedInstance().currentRoute
            
            for desc in route.outputs {
                if desc.portType == AVAudioSession.Port.headphones {
                    return true
                }
            }
            return false
        }
    }
    
    // MARK: ===================================工具类:传感器 =========================================
    //  系统类库 CoreMotion
    /// 传感器
    public struct Sensors {
        
        // Check if the accelerometer is available
        /// 检查加速度计是否可用
        public static var isAccelerometerAvailable: Bool {
            
            return CMMotionManager.init().isAccelerometerAvailable
        }
        
        // Check if gyroscope is available
        /// 检查陀螺仪是否可用
        public static var isGyroAvailable: Bool {
            
            return CMMotionManager.init().isGyroAvailable
        }
        
        
        // Check if magnetometer is available
        /// 检查磁力计是否可用
        public static var isMagnetometerAvailable: Bool {
            
            return CMMotionManager.init().isMagnetometerAvailable
        }
        
        // Check if device motion is available
        /// 检查设备运动是否可用
        public static var isDeviceMotionAvailable: Bool {
            
            return CMMotionManager.init().isDeviceMotionAvailable
        }
    }
    
    
    
    // MARK: ===================================工具类:硬件信息=========================================
    
    /// 硬件信息
    public struct Hardware {
        
        // Number of processors.
        /// 处理器数量。
        public static var processorsNumber: Int {
            
            return ProcessInfo().processorCount
        }
        
        // Number of active processors.
        /// 活动处理器的数量。
        public static var activeProcessorsNumber: Int {
            
            return ProcessInfo().activeProcessorCount
        }
        
        
        // Physical memory of the device in megabytes.
        /// 设备运存 默认 GB
        /// - Parameter sizeScale: 单位
        /// - Returns: 结果
        public static func physicalMemory(with sizeScale: MeasureUnit = .gigabytes) -> Double {
            
            let physicalMemory = Float(ProcessInfo().physicalMemory)
            
            switch sizeScale {
            case .bytes:
                return Double(physicalMemory)
            case .kilobytes:
                return Double(physicalMemory / 1024)
            case .megabytes:
                return Double(physicalMemory / 1024 / 1024)
            case .gigabytes:
                return Double(physicalMemory / 1024 / 1024 / 1024)
            case .percentage:
                return 100.0
            }
        }
        
        // The name of the system.
        /// 系统的名称
        public static var systemName: String {
            
            return UIDevice().systemName
        }
        
        /// The version of the system. Private use.
        private static var _systemVersion: String {
            
            return UIDevice().systemVersion
        }
        
        // The version of the system.
        /// 系统的版本。
        public static var systemVersion: AgSystem.SystemVersion {
            
            return AgSystem.SystemVersion.init(_systemVersion)
        }
        
        // The current boot time expressed in seconds.
        /// 当前启动时间以秒为单位表示
        public static var bootTime: TimeInterval {
            
            return ProcessInfo().systemUptime
        }
        
        @available(iOS 9.0,*)
        // Check if the low power mode is currently enabled (iOS 9 and above).
        /// 检查当前是否启用了低功耗模式（iOS 9 及更高版本）。
        public static var isLowPowerModeEnabled: Bool {
            
            return ProcessInfo().isLowPowerModeEnabled
        }
        
    }
    
}
