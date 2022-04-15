//
//  AG_String_Extension.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/23.
//

import Foundation
import UIKit

public extension String {
    
    /// 转换为对应的json对象
    func ag_ToJSONObject() -> Any? {
        guard let data = self.data(using: .utf8) else { return nil }
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        return json
    }
    
    /// 字符串转数组
    /// - Parameter separator: 分隔符
    /// - Returns: 数组
    func ag_ToArray(separator: String) -> Array<String> {
        return self.components(separatedBy: separator)
    }
    /// Json字符串转Dic
    /// - Returns: 字典
    func ag_Json2Dictionary() -> [String : Any] {
        var result = [String : Any]()
        guard !self.isEmpty else { return result }
        guard let dataSelf = self.data(using: .utf8) else {
            return result
        }
        if let dic = try? JSONSerialization.jsonObject(with: dataSelf,
                           options: .mutableContainers) as? [String : Any] {
            result = dic
        }
        return result
    
    }
    
    /// 清理串首尾的空格及换行
    var agTrimmingWhitespacesAndNewlines: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// 从 .Assets 获取对应的图片
    var ag_Image:UIImage?{
        return UIImage(named: self)
    }
}


public extension String {
    
    /// base64编码
    var base64Encode: String? {
        return self.data(using: .utf8)?.base64EncodedString()
    }
    
    /// base64解码
    var base64Decode: String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    /// URL编码 alamofire的方案
    var ag_UrlEncode: String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        let afURLQueryAllowed = CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)

        return self.addingPercentEncoding(withAllowedCharacters: afURLQueryAllowed) ?? ""
    }

    /// unicode编码
    var ag_UnicodeEncode: String {
        var tempStr = String()
        for v in self.utf16 {
            if v < 128 {
                tempStr.append(Unicode.Scalar(v)!.escaped(asASCII: true))
                continue
            }
            let codeStr = String(v, radix: 16, uppercase: false)
            tempStr.append("\\u" + codeStr)
        }

        return tempStr
    }

    /// unicode解码
    var ag_UnicodeDecode: String {
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
}
