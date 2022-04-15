//
//  AG_UserDefaults_Extension.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/24.
//

import Foundation

public extension UserDefaults {
    
    func agSet<T: Codable>(object: T , for Key: String ) throws {
        
        let jsonData = try JSONEncoder().encode(object)
        
        set(jsonData, forKey: Key)
    }
    
    func agGet<T: Codable>(objectType: T.Type, for key:String) throws -> T? {
        guard let result = value(forKey: key) as? Data  else { return nil }
        
        return try JSONDecoder().decode(objectType, from: result)
    }
    
    
    
    subscript(key:String) -> Any? {
        get {
            return object(forKey:key)
        }
        
        set {
            set(newValue, forKey: key)
        }
    }
    
    func float(for key: String) -> Float? {
        return object(forKey: key) as? Float
    }
    
    func date(forKey key: String) -> Date? {
        return object(forKey: key) as? Date
    }
    
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }
    
    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        set(data, forKey: key)
    }
    
    
}
