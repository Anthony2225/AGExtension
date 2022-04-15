//
//  AG_DispatchQueue_Extension.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/24.
//

import Foundation
import UIKit


public enum AgQueue {
    case main
    case backGround
    case userInteractive
    case userInitiated
    case utility
    case `default`
    case custom(aQueue:DispatchQueue)
    
    public var queue: DispatchQueue {
        switch self {
        case .main:
            return  DispatchQueue.main
        case .backGround:
            return  DispatchQueue.global(qos: .background)
        case .userInteractive:
            return  DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:
            return  DispatchQueue.global(qos: .userInitiated)
        case .utility:
            return  DispatchQueue.global(qos: .utility)
        case .default:
            return  DispatchQueue.global(qos: .default)
        case .custom(let aQueue):
            return  aQueue
        }
    }
}

public class AgTask {
    
    public let queue:AgQueue
    
    public init(queue:AgQueue){
        self.queue = queue
    }
    
    public final func run (_ closures: @escaping ()  -> Void){
        queue.queue.async {
            _ = closures
        }
    }
    
    public final func after(_ secondes:Double ,closures : @escaping ()  -> Void){
        queue.queue.async {
            AgTask.waitClosures(secondes)()
            _ = closures
        }
    }
    
}

extension AgTask {
    
    
    /// 主进程执行
    /// - Returns: AgTask
    @discardableResult public static func main() -> AgTask {
        return AgTask(queue: AgQueue.main)
    }
    
    /// 最低优先级，等同于 DISPATCH_QUEUE_PRIORITY_BACKGROUND. 用户不可见，比如：在后台存储大量数据
    /// - Returns: AgTask
    @discardableResult public static func backGround() -> AgTask {
        return AgTask(queue: AgQueue.backGround)
    }
    
    /// 用户交互相关，为了好的用户体验，任务需要立马执行。使用该优先级用于 UI 更新，事件处理和小工作量任务，在主线程执行
    /// - Returns: AgTask
    @discardableResult public static func userInteractive() -> AgTask {
        return AgTask(queue: AgQueue.userInteractive)
    }
    
    /// 优先级等同于 DISPATCH_QUEUE_PRIORITY_HIGH,需要立刻的结果
    /// - Returns: AgTask
    @discardableResult public static func userInitiated() -> AgTask {
        return AgTask(queue: AgQueue.userInitiated)
    }
    
    /// 优先级等同于 DISPATCH_QUEUE_PRIORITY_LOW，可以执行很长时间，再通知用户结果。比如：下载一个大文件，网络，计算
    /// - Returns: AgTask
    @discardableResult public static func utility() -> AgTask {
        return AgTask(queue: AgQueue.utility)
    }
    
    /// 默认优先级,优先级等同于 DISPATCH_QUEUE_PRIORITY_DEFAULT，建议大多数情况下使用默认优先级
    /// - Returns: AgTask
    @discardableResult public static func global() -> AgTask {
        return AgTask(queue: AgQueue.default)
    }
    
    
    /// 自定义进程
    /// - Parameter queue: 自定义界别
    /// - Returns: AgTask
    @discardableResult public static func custom(_ queue: DispatchQueue) -> AgTask {
        return AgTask(queue: AgQueue.custom(aQueue: queue))
    }
    
    
    
    fileprivate static func waitClosures(_ seconds: Double )  -> () ->Void {
        return {
            let msSeconds = Int64(seconds * Double(NSEC_PER_SEC))
            let time = DispatchTime.now() + Double(msSeconds) / Double(NSEC_PER_SEC)
            let semap = DispatchSemaphore(value: 0)
            
            _ = semap.wait(timeout: time)
        }
    }
    
    
}


public extension DispatchQueue {
    
    
    /// 判断线程是不是主线程
    static var isMainQueue: Bool{
        enum Static {
            static var key: DispatchSpecificKey<Void> = {
                let key = DispatchSpecificKey<Void>()
                DispatchQueue.main.setSpecific(key: key, value: ())
                return key
            }()
        }
        return DispatchQueue.getSpecific(key: Static.key) != nil
    }
    
    
    
    /// 判断当前是不是在主线程
    /// - Parameter queue: queue
    /// - Returns: true/false
    static func isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()

        queue.setSpecific(key: key, value: ())
        defer { queue.setSpecific(key: key, value: nil) }

        return DispatchQueue.getSpecific(key: key) != nil
    }
    
    
    
    /// 延迟闭包
    /// - Parameters:
    ///   - delay: 延迟时间
    ///   - qos: qos
    ///   - flags: flags
    ///   - work: 执行闭包
    func asyncAfter(delay: Double,
                    qos: DispatchQoS = .unspecified,
                    flags: DispatchWorkItemFlags = [],
                    execute work: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, qos: qos, flags: flags, execute: work)
    }
    
    
    /// 延迟闭包
    /// - Parameters:
    ///   - delay: 延迟时间
    ///   - action: 执行闭包
    func after(delay: Double, action: @escaping () -> Void) -> () -> Void {
        var lastFireTime = DispatchTime.now()
        let deadline = { lastFireTime + delay }
        return {
            self.asyncAfter(deadline: deadline()) {
                let now = DispatchTime.now()
                if now >= deadline() {
                    lastFireTime = now
                    action()
                }
            }
        }
    }
}
