//
//  AGLog.swift
//  AGWheel
//  https://github.com/Anthony2225
//  Created by Anthony on 2022/3/21.
//

import Foundation

/// log 日志名
private let ag_logCacheDomainName = "AG-log.txt"
private let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
/// log 日志缓存路径
private let ag_logCacheFilePath = cachePath.appendingPathComponent(ag_logCacheDomainName)

/// 只有 debug 模式才打印
#if DEBUG
private let shouldLog : Bool = true
#else
private let shouldLog : Bool = false
#endif

//@inlinable public func aLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
//
//    print(<#T##items: Any...##Any#>)
//}

/// 打印错误信息
@inlinable public func AgLogError(_ message:@autoclosure () -> String,file:StaticString = #file, function:StaticString = #function, line:UInt = #line)
{
    AgLog.log(message(), type: .error, file: file, function: function, line: line)
}

/// 打印警告信息
@inlinable public func AgLogWarn(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
    AgLog.log(message(), type: .warning, file: file, function: function, line: line)
}

/// 打印重要信息
@inlinable public func AgLogInfo(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
    AgLog.log(message(), type: .info, file: file, function: function, line: line)
}

/// 专门打印网络日志，可以单独关闭 🌐
@inlinable public func AgLogNet(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
    AgLog.log(message(), type: .netLog, file: file, function: function, line: line)
}
/// log等级划分开发级 ✅
@inlinable public func AgLogDebug(_ message: @autoclosure () -> String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {
    AgLog.log(message(), type: .debug, file: file, function: function, line: line)
}
/// log等级划分最低级 ⚪ 可忽略
@inlinable public func AgLogIgnore(_ message: @autoclosure () -> String,
                         file: StaticString = #file,
                         function: StaticString = #function,
                         line: UInt = #line) {
    AgLog.log(message(), type: .ignore, file: file, function: function, line: line)
}

public enum LogDegree:Int{
    ///忽略,最低级.不打印
    case ignore     = 0
    ///debug 级别
    case debug      = 1
    /// 专门打印请求结果,,可以单独关闭
    case netLog     = 2
    /// 打印重要信息
    case info       = 3
    /// 警告级别
    case warning    = 4
    ///错误
    case error      = 5

}


public class AgLog {
    /// 获取日志缓存文件路径
    public static var getLogFilePath:URL  {
        return ag_logCacheFilePath
    }
    /// 日志打印级别,,小于该级别的信息会被忽略
    public static var defaultLogDegree:LogDegree  = .ignore
    
    /// 是否打印 网络数据
    public static var showNetLog:Bool = true
    
    ///缓存保存最长时间///如果需要自定义时间一定要在addFileLog之前
    public static var maxLogAge : TimeInterval? = 60 * 60 * 24 * 7
    
    /// 是否写入 log日志文件
    public static var addAgLogFile:Bool = false {
        didSet {
            if addAgLogFile{
                deleteOldFiles()
            }
        }
    }
    
    
    
    /// 删除旧的 打印日志
    private static func deleteOldFiles() {
        let url = ag_logCacheFilePath
        if !FileManager.default.fileExists(atPath: url.path) {
            return
        }
        guard let age :TimeInterval = maxLogAge,age != 0 else { return }
        
        let expirationDate = Date(timeIntervalSinceNow: -age)
        let resourceKeys: [URLResourceKey] = [.isDirectoryKey, .contentModificationDateKey, .totalFileAllocatedSizeKey]
        var resourceValues: URLResourceValues
        do {
            resourceValues = try url.resourceValues(forKeys: Set(resourceKeys))
            if let modifucationDate = resourceValues.contentModificationDate {
                if modifucationDate.compare(expirationDate) == .orderedAscending {
                    try? FileManager.default.removeItem(at: url)
                }
            }
        } catch let error {
            debugPrint("AgLog error: \(error.localizedDescription)")
        }
        
    }
    
    /// log 最低等级🆓  可以忽略
    public static func ignore (_ message: String,
                               file: StaticString = #file,
                               function: StaticString = #function,
                               line: UInt = #line) {
        log(message, type: .ignore, file: file, function: function, line: line)
    }
    /// debug等级划分开发级 📍
    public static func debug(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .debug, file: file, function: function, line: line)
    }
    /// 专门打印网络日志，可以单独关闭 🌐
    public static func net(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .netLog, file: file, function: function, line: line)
    }
    
    /// info等级划分信息级 📌
    public static func info(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .info, file: file, function: function, line: line)
    }
    /// warn等级划分警告级 ⚠️
    public static func warn(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .warning, file: file, function: function, line: line)
    }
    /// error等级划分最高级 🧨
    public static func error(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .error, file: file, function: function, line: line)
    }
    
    /// 打印
    /// - Parameters:
    ///   - message: 打印信息
    ///   - type: 打印等级
    ///   - file: 文件名
    ///   - function: 方法名
    ///   - line: 所在行数
    public static func log(_ message: @autoclosure () -> String,type: LogDegree,file: StaticString,function: StaticString,line: UInt) {
        // 当前打印级别 小于 设置的默认 打印级别,,所以不打印日志
        if type.rawValue < defaultLogDegree.rawValue {return}
        
        /// 如果是专门打印网络请求的,但是设置的是不打印日志,,也直接返回
        if type == .netLog, !showNetLog{return}
        
        let fileName = String(describing: file).lastPathComponent
        let formattedMsg =  String(format: "所在类:%@ \n 方法名:%@ \n 所在行:%d \n<<<<<<<<<<<<<<<< 信息 >>>>>>>>>>>>>>>>\n\n %@ \n\n<<<<<<<<<<<<<<<<END>>>>>>>>>>>>>>>>\n\n", fileName, String(describing: function), line, message())
        AgLogFormatter.log(message: formattedMsg, type: type, addFileLog: addAgLogFile)
        
    }
    
}

/// 日志格式
class AgLogFormatter {
    
    static var dateFormatter = DateFormatter()
    
    static func log(message logMessage: String, type: LogDegree, addFileLog : Bool) {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        var logLevelStr:String
        switch type {
        case .ignore:
            logLevelStr = "🆓 Ignore 🆓"
        case .debug:
            logLevelStr = "📍 Debug 📍"
        case .netLog:
            logLevelStr = "🌐 Network 🌐"
        case .info:
            logLevelStr = "📌 Info 📌"
        case .warning:
            logLevelStr = "⚠️ Warning ⚠️"
        case .error:
            logLevelStr = "🧨 Error 🧨"

        }
        let dateStr = dateFormatter.string(from: Date())
        let finalMessage = String(format: "\n%@ | %@ \n %@", logLevelStr, dateStr, logMessage.replaceUnicode)
        
        /// 打印的时候同步写入到日志
        if addFileLog {
            appendText(fileURL: ag_logCacheFilePath, string: "\(finalMessage)")
        }
        guard shouldLog else {return}
        print(finalMessage.replaceUnicode)
        
    }
    
    
    
    /// 在log日志的末尾追加新内容
    /// - Parameters:
    ///   - fileURL: 文件路径
    ///   - string: 追加内容
   static func appendText(fileURL: URL, string: String){
        do {
            //如果文件不存在则新建一个
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                FileManager.default.createFile(atPath: fileURL.path, contents: nil)
            }
             
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            let stringToWrite = "\n" + string
             
            //找到末尾位置并添加
            fileHandle.seekToEndOfFile()
            fileHandle.write(stringToWrite.data(using: String.Encoding.utf8)!)
             
        } catch let error as NSError {
            print("AGLog logTxt writer failed to append: \(error)")
        }
    }
}



extension String {
    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }
    

    var pathExtension: String {
        return fileURL.pathExtension
    }

    var lastPathComponent: String {
        return fileURL.lastPathComponent
    }
    
    var replaceUnicode: String {
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        guard let tempData = tempStr3.data(using: String.Encoding.utf8) else {
            return "unicode转码失败"
        }
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
    
}
