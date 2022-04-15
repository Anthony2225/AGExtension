//
//  AG_NotificationCenter_Extension.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/24.
//

import Foundation


public extension NotificationCenter {
    
    /// NotificationCenter通知监听闭包
    /// - Parameters:
    ///   - name: 通知名
    ///   - obj: 对象
    ///   - queue: 线程
    ///   - block: 执行闭包
    func ag_Add(name: String,
             obj: Any? = nil,
             queue: OperationQueue? = .main,
             closures: @escaping (_ notification: Notification) -> Void) {
        
        var handler: NSObjectProtocol!
        handler = addObserver(forName: NSNotification.Name(rawValue: name), object: obj, queue: queue) { [unowned self] in
            self.removeObserver(handler!)
            closures($0)
        }
        
    }
    
    
    
    
    
}
