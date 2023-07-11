//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 7/10/23.
//

// All enums with a Raw value

extension JSON where Self: RawRepresentable, RawValue: JSON {
    public func toJSON() -> String {
        return self.rawValue.toJSON()
    }
}

// Enums with Associated Values

public typealias AssociatedValues = (JSON...) -> ()
public protocol JSONEnum: JSON {
    // static var names: [String] { get set }
    func allCases(_ run: AssociatedValues)
    func prettyJSON(_ intend: Int) -> String
    static var decoding: [String : () -> Self] { get }
}
extension JSONEnum {
    public func superEncode(_ name: String, values: [JSON]) -> String {
        if values.isEmpty {
            return "{\"\(name)-1\": null}"
        }
        let wo = values.enumerated().map({ i, j -> String in
            return "\"\(name)-\(i+1)\": \(j.toJSON())"
        })
        return "{" + wo.joined(separator: ", ") + "}"
    }
    public func toJSON() -> String {
        let name = String("\(self)".split(separator: "(")[0])
        
        var found = ""
        allCases { (foo: JSON...) in
            found = superEncode(name, values: foo)
        }
        return found
    }
    
    public func encode(to encoder: Encoder) throws {}
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: String.self)
        func decode<T: Decodable>(_ a: T.Type,_ forKey: String) -> T? { try? values.decode(a, forKey: forKey) }
        func exists(_ forKey: String) -> Bool { (try? values.decodeNil(forKey: forKey)) == true }
        
        let name = String(values.allKeys[0].split(separator: "-")[0])
        
        _values.append(values)// = values
        _onDecoding.append(0)// = 0
        _name.append(name)// = name
        
        guard let o = Self.decoding[name]?() else {
            throw "Decoding Failed"
        }
        _name.removeLast()
        _onDecoding.removeLast()
        _values.removeLast()
        self = o
    }
    
}
extension KeyedDecodingContainer where Key == String {
    public func decode<T: Decodable>(_ some: T.Type,_ key: String) -> T? {
        return try? self.decode(some, forKey: key)
    }
//    public func decode<T: JSONSuperiorRawValues>(_ some: T.Type,_ key: String) -> T? {
//        return T.safeDecode(key)
//        //return try? self.decode(some, forKey: key)
//    }
}

var _values: [KeyedDecodingContainer<String>] = []
var _onDecoding: [Int] = []// = 0
var _name: [String] = []// = ""
public func d<T: Decodable>() -> T {
    // print(_name)
    let _name = _name.last!
    let _values = _values.last!
    _onDecoding[_onDecoding.count-1] += 1
    let _onDecoding = _onDecoding.last!
    
    let foo: T.Type = T.self
    if _onDecoding == 1 {
        if let o = _values.decode(foo, "\(_name)") {
            return o
        }
    }
    if let o = _values.decode(foo, "\(_name)-\(_onDecoding)") {
        return o
    }
    fatalError()
}

public struct P<T: Decodable> {
    public static var `_`: T {
        d()
    }
}

extension String: Error {}
extension String: CodingKey {
    public init?(stringValue: String) {
        self = stringValue
    }
    public var stringValue: String {
        return self
    }
    public init?(intValue: Int) {
        return nil
    }
    public var intValue: Int? {
        nil
    }
}

extension JSON {
    public func fix<T>() -> T {
        return self as! T
    }
}

enum Magic: JSONEnum {
    case foo(Int?)
    case bar
    case magic(Int, Int)
    indirect case wow([Self])
    case flow(Int, Double)
    
    // Convert the things INTO JSON
    func allCases(_ run: AssociatedValues) {
        switch self {
        case let .foo(i): run(i)
        case .bar: run()
        case let .magic(i, j): run(i, j)
        case let .wow(i): run(i)
        case let .flow(i, j): run(i, j)
        }
    }
    // Help specify the types when turning JSON back into Swift
    static var decoding: [String : () -> Self] = [
        "foo" : { .foo(d()) },
        "bar" : { .bar },
        "magic" : { .magic(d(), d()) },
        "wow" : { .wow(d()) },
        "flow" : { .flow(d(), d()) },
    ]
    
}
