//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 8/2/21.
//

import Foundation

public protocol JSON: Encodable, Decodable {
    func toJSON() -> String
    func prettyJSON(_ indent: Int) -> String
}
public extension JSON {
    static func decode(_ json: String) -> Self {
        return try! JSONDecoder().decode(Self.self, from: Data(json.utf8))
    }
    static func safeDecode(_ json: String) -> Self? {
        return try? JSONDecoder().decode(Self.self, from: Data(json.utf8))
    }
    func encode() -> String {
        return toJSON()
    }
}

public protocol JSONSuperiorRawValues: JSON {}

public extension JSONSuperiorRawValues where Self: RawRepresentable, Self.RawValue == String {
    init?(rawValue: String) {
        if let o = Self.safeDecode(rawValue) {
            self = o
        } else {
            return nil
        }
    }
    var rawValue: String { toJSON() }
    
    static func decode(_ json: String) -> Self {
        return Self.init(rawValue: RawValue.init(stringLiteral: json))!
    }
    func encode() -> String {
        print("Hi")
        return rawValue.encode()
    }
}

public extension JSONSuperiorRawValues where Self: RawRepresentable, Self.RawValue: JSON & ExpressibleByStringLiteral, Self.RawValue.StringLiteralType == String {
    static func decode(_ json: String) -> Self {
        return Self.init(rawValue: RawValue.init(stringLiteral: json))!
    }
    func encode() -> String {
        return rawValue.encode()
    }
}

public protocol JSONSuperiorObject: JSONObject, RawRepresentable, ExpressibleByStringLiteral {}

public extension JSONSuperiorObject {
    
    typealias RawValue = String
    typealias StringLiteralType = String
    
    static func decode(_ json: String) -> Self {
        return Self.init(rawValue: RawValue.init(stringLiteral: json))!
    }
    func encode() -> String {
        return rawValue.encode()
    }
    
    init(stringLiteral value: String) {
        self = Self.decode(value)
    }
    
    init?(rawValue: String) {
        if let o = Self.safeDecode(rawValue) {
            self = o
        } else {
            return nil
        }
    }
    var rawValue: String { toJSON() }
}


public protocol AutoJSON: JSON {}

public protocol EasyDict {
    func toJSON2() -> String
    func toPrettyJSON2(_ indent: Int) -> String
}
public protocol StringDict {
    func toJSON2() -> String
    func toPrettyJSON2(_ indent: Int) -> String
}
public protocol ComplexDict {
    func toJSON2() -> String
    func toPrettyJSON2(_ indent: Int) -> String
}


// JSON Objects
public protocol JSONObject: JSON {
    var json: [String : JSON] { get }
}
