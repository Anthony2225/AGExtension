//
//  AG_Define.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/25.
//

import Foundation
// MARK:- 打印输出
public func ALog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
#if DEBUG

    let fileName = (file as NSString).lastPathComponent
    print("|\n|\n|\n 时间:\(currentTime) \n 所在类: \(fileName) \n 所在方法: \(funcName) \n 所在行:\(lineNum) \n ------------------------\n 打印内容:\(message) \n ------------------------\n|\n|\n|")
#endif
}

public  func aprint<T>(_ message: T) {
    #if DEBUG
    print(message)
    #endif
}


public var  currentTime: String {
    let  dateFormatter = DateFormatter()
    dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss:SSS"
    let dateStr = dateFormatter.string(from: Date())
    return dateStr
}
