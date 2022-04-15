//
//  AG_Dictionary_Extension.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/24.
//

import Foundation


public extension Dictionary {
    
    /// 检查字典里是否含有 某个 key
    /// - Parameter key:  待检查的 key
    /// - Returns: true have | false don't have `
    func ag_Contains(_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    /// JsonString转为字典
    /// - Parameter json: JSON字符串
    /// - Returns: 字典
    static func ag_JsonToDictionary(json: String) -> Dictionary<String, Any>? {
        if let data = (try? JSONSerialization.jsonObject(
            with: json.data(using: String.Encoding.utf8,
                            allowLossyConversion: true)!,
            options: JSONSerialization.ReadingOptions.mutableContainers)) as? Dictionary<String, Any> {
            return data
        } else {
            return nil
        }
    }
    
    /// 字典转换为JSONString
    func ag_ToJSON() -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions()) {
            let jsonStr = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            return String(jsonStr ?? "")
        }
        return nil
    }
    
    
    
}
