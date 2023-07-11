//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 7/10/23.
//

// Basic Types
extension AutoJSON {
    public func toJSON() -> String {
        return "\(self)"
    }
}

extension Int: AutoJSON {}
extension UInt8: AutoJSON {}
extension UInt16: AutoJSON {}
extension UInt32: AutoJSON {}
extension UInt64: AutoJSON {}
extension Double: AutoJSON {}
extension Float: AutoJSON {}
extension Bool: AutoJSON {}

// String
extension String: JSON {
    //var _json: JSON { return self }
    public func toJSON() -> String {
        var o = self
        if o.contains("\\") { o = o.replacingOccurrences(of: "\\", with: "\\\\") }
        if o.contains("\n") { o = o.replacingOccurrences(of: "\n", with: "\\n") }
        if o.contains("\r") { o = o.replacingOccurrences(of: "\r", with: "\\r") }
        if o.contains("\t") { o = o.replacingOccurrences(of: "\t", with: "\\t") }
        if o.contains("\"") { o = o.replacingOccurrences(of: "\"", with: "\\\"") }
        return "\"\(o)\""
    }
}

// The Array
extension Array: JSON where Element: JSON {
    public func toJSON() -> String {
        return "[" + map({ $0.toJSON() }).joined(separator: ", ") + "]"
    }
}
extension Array: AutoJSON where Element: AutoJSON {}


// The Set
extension Set: JSON where Element: JSON {
    public func toJSON() -> String {
        return "[" + map({ $0.toJSON() }).joined(separator: ", ") + "]"
    }
}
extension Set: AutoJSON where Element: AutoJSON {}



// The Dictionary
extension Dictionary: JSON where Key: JSON, Value: JSON {
    public func toJSON() -> String {
        if let a = self as? StringDict {
            return a.toJSON2()
        } else if let a = self as? EasyDict {
            return a.toJSON2()
        }
        return toJSON2()
    }
}

extension Dictionary: EasyDict where Key: AutoJSON, Value: JSON {
    public func toJSON2() -> String {
        let quote = #"""#
        let foo = map({ quote + $0.toJSON() + quote + ":" + $1.toJSON() })
        let bar = foo.joined(separator: ", ")
        return "{" + bar + "}"
    }
}
extension Dictionary: StringDict where Key == String, Value: JSON {
    public func toJSON2() -> String {
        let foo = map({ $0.toJSON() + ":" + $1.toJSON() })
        let bar = foo.joined(separator: ", ")
        return "{" + bar + "}"
    }
}
extension Dictionary: ComplexDict where Key: JSON, Value: JSON {
    public func toJSON2() -> String {
        let foo = map({ $0.toJSON() + ", " + $1.toJSON() })
        let bar = foo.joined(separator: ", ")
        return "[" + bar + "]"
    }
}

// The Optional
extension Optional: JSON where Wrapped: JSON {
    public func toJSON() -> String {
        return self?.toJSON() ?? "null"
    }
}
