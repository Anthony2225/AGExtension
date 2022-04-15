//
//  AG_System.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/24.
//

import Foundation
//import UIAdapter
//import SnapKit

public struct AgSystem {

    // MARK: Types
    public enum BateryState:Int {
        
        case unknown
        /// 未接通电源
        case unplugged
        /// 正在充电
        case charging
        /// 电池充满电
        case full
        
        
        /// 电池状态描述
        public var describeString:String {
            switch self {
            case .unknown:
                return "未知"
            case .unplugged:
                return "未充电"
            case .charging:
                return "充电中"
            case .full:
                return "电量充足"
            }
        }
    }
    
    /// The size scale to decide how you want to obtain size information.
    ///
    /// - bytes:     In bytes.
    /// - kilobytes: In kilobytes.
    /// - megabytes: In megabytes.
    /// - gigabytes: In gigabytes.
    public enum MeasureUnit {
        /// 字节
        case bytes
        /// 千字节
        case kilobytes
        /// 兆字节
        case megabytes
        /// 千兆字节 GB
        case gigabytes
        /// 百分
        case percentage
    }

    fileprivate var Later_ios11: Bool {
        guard #available(iOS 11.0, *) else {
            return false
        }
        return true
    }
    
    fileprivate var Later_ios12: Bool {
        guard #available(iOS 12.0, *) else {
            return false
        }
        return true
    }
    
    fileprivate var Later_ios13: Bool {
        guard #available(iOS 13.0, *) else {
            return false
        }
        return true
    }
    
    fileprivate var Later_ios14: Bool {
        guard #available(iOS 14.0, *) else {
            return false
        }
        return true
    }
    
    fileprivate var Later_ios15: Bool {
        guard #available(iOS 15.0, *) else {
            return false
        }
        return true
    }
    fileprivate var Later_ios16: Bool {
        guard #available(iOS 16.0, *) else {
            return false
        }
        return true
    }
    
}

/// iOS 11 之后
public let Later_11:Bool = AgSystem().Later_ios11
/// iOS 12 之后
public let Later_12:Bool = AgSystem().Later_ios12
/// iOS 13 之后
public let Later_13:Bool = AgSystem().Later_ios13
/// iOS 14 之后
public let Later_14:Bool = AgSystem().Later_ios14
/// iOS 15之后
public let Later_15:Bool = AgSystem().Later_ios15
/// iOS 16之后
public let Later_16:Bool = AgSystem().Later_ios16


