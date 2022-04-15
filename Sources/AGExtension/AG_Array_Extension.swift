//
//  AG_Array_Extension.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/23.
//

import Foundation


public extension Array {
    
    
    /// 不越界的数组取值
    /// - Parameter index: 取值索引
    /// - Returns: 正确的索引 就返回正确的值.错误的返回 nil
    func safeObject(at index: Int) -> Self.Element? {
        guard (self.startIndex ..< self.endIndex).contains(index) else { return nil }
        return self[index]
    }

    
    // var testArr1 = ["123","123","hha ","hha","heiehiehe"]
    // var testArr2 = [People(name: "张三", age: 12),People(name: "李四", age: 14),People(name: "王五", age: 12),People(name: "张三", age: 10)]
    // testArr1.filterDuplicate({$0})   |  testArr2.filterDuplicate({$0.age})
    /// 数组去重(保持原数组顺序)
    /// - Returns: 去重后的数组
    func ag_FilterDuplicate<E: Hashable>(_ filter: (Element) -> E) -> [Element] {
        if self.isEmpty {
            return self
        }
        var sets = Set<E>(minimumCapacity: self.count)
        return self.filter { sets.insert(filter($0)).inserted }
    }
    
    
    ///  追加不重复的元素(保持顺序追加)
    /// filter: 过滤条件,用来判断是否重复  ex. {$0}   {$0.name}
    /// - Returns: 追加过的数组
    @discardableResult mutating func ag_Append<E: Hashable>(of array: [Element]?, filter: (Element) -> E) -> [Element] {
        guard let array = array, !array.isEmpty else {
            return self
        }
        var sets = Set<E>(minimumCapacity: self.count + array.count)
        sets.formUnion(self.map { filter($0) })
        self.append(contentsOf: array.filter { sets.insert(filter($0)).inserted })
        return self
    }
    
    /// 转换为JSONString
    /// - Returns: json string
    var ag_ToJSONString: String? {
        guard JSONSerialization.isValidJSONObject(self),
              let jsonData = try? JSONSerialization.data(withJSONObject: self)
        else {
            return nil
        }

        return String(data: jsonData, encoding: .utf8)
    }
}

public extension Array where Element: Equatable {
    
    /// 数组去重 只针对 元素遵守 Equatabl协议的
    /// - Returns: 去重后的数组
    func ag_RemoveDuplicate()  -> Self{
        return self.enumerated().filter { (index,elem) in
            return self.firstIndex(of: elem) == index
        }.map { (_,elem) in
            elem
        }
    }
    
    /// 获取数组中的指定元素的索引值
    /// - Parameter item: 元素
    /// - Returns: 索引值数组
    func ag_Indexes(_ item: Element) -> [Int] {
        var indexes = [Int]()
        for index in 0..<count where self[index] == item {
            indexes.append(index)
        }
        return indexes
    }
    
    
    /// 获取元素首次出现的位置索引
    /// - Parameter item: 元素
    /// - Returns: 索引值
    func ag_FirstIndex(_ item: Element) -> Int? {
        for (index, value) in self.enumerated() where value == item {
            return index
        }
        return nil
    }
    
    /// 获取元素最后出现的位置
    /// - Parameter item: 元素
    /// - Returns: 索引值
    func ag_LastIndex(_ item: Element) -> Int? {
        let indexs = ag_Indexes(item)
        return indexs.last
    }
    
    
    
    /// 删除数组的中的元素(可删除第一个出现的或者删除全部出现的)
    /// - Parameters:
    ///   - element: 要删除的元素
    ///   - isRepeat: 是否删除重复的元素
    @discardableResult
    mutating func ag_Remove(_ element: Element, isRepeat: Bool = true) -> Array {
        var removeIndexs: [Int] = []
        
        for i in 0 ..< count {
            if self[i] == element {
                removeIndexs.append(i)
                if !isRepeat { break }
            }
        }
        // 倒序删除
        for index in removeIndexs.reversed() {
            self.remove(at: index)
        }
        return self
    }
    
    /// 从删除数组中删除一个数组中出现的元素，支持是否重复删除, 否则只删除第一次出现的元素
    /// - Parameters:
    ///   - elements: 被删除的数组元素
    ///   - isRepeat: 是否删除重复的元素
    @discardableResult
    mutating func ag_RemoveArray(_ elements: [Element], isRepeat: Bool = true) -> Array {
        for element in elements {
            if self.contains(element) {
                self.ag_Remove(element, isRepeat: isRepeat)
            }
        }
        return self
    }
}



public extension Array where Element: NSObjectProtocol {
    
    /// 删除数组中遵守NSObjectProtocol协议的元素
    /// - Parameters:
    ///   - object: 元素
    ///   - isRepeat: 是否删除重复的元素
    @discardableResult
    mutating func ag_Remove(object: NSObjectProtocol, isRepeat: Bool = true) -> Array {
        var removeIndexs: [Int] = []
        for i in 0..<count {
            if self[i].isEqual(object) {
                removeIndexs.append(i)
                if !isRepeat {
                    break
                }
            }
        }
        for index in removeIndexs.reversed() {
            self.remove(at: index)
        }
        return self
    }
    
    /// 删除一个遵守NSObjectProtocol的数组中的元素，支持重复删除
    /// - Parameters:
    ///   - objects: 遵守NSObjectProtocol的数组
    ///   - isRepeat: 是否删除重复的元素
    @discardableResult
    mutating func ag_RemoveArray(objects: [NSObjectProtocol], isRepeat: Bool = true) -> Array {
        for object in objects {
            if self.contains(where: {$0.isEqual(object)} ){
                self.ag_Remove(object: object, isRepeat: isRepeat)
            }
        }
        return self
    }
}


public extension Array where Self.Element == String {
    
    /// 数组转字符转（数组的元素是 字符串），如：["1", "2", "3"] 连接器为 - ，那么转化后为 "1-2-3"
    /// - Parameter separator: 连接器
    /// - Returns: 转化后的字符串
    func ag_ToStrinig(separator: String = "") -> String {
        return self.joined(separator: separator)
    }
    
    
}
