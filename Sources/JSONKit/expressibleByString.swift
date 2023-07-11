//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 7/10/23.
//

extension Bool: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = Self.safeDecode(value) ?? false
    }
}
extension Double: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = Self.safeDecode(value) ?? .zero
    }
}

extension Array: ExpressibleByUnicodeScalarLiteral where Element: JSON {
    public init(unicodeScalarLiteral value: String) {
        self = Self.safeDecode(value) ?? []
    }
}
extension Array: ExpressibleByExtendedGraphemeClusterLiteral where Element: JSON {
    public init(extendedGraphemeClusterLiteral value: String) {
        self = Self.safeDecode(value) ?? []
    }
}
extension Array: JSONSuperiorRawValues, ExpressibleByStringLiteral where Element: JSON {
    public init(stringLiteral value: String) {
        self = Self.safeDecode(value) ?? []
    }
}

extension Set: ExpressibleByUnicodeScalarLiteral where Element: JSON {
    public init(unicodeScalarLiteral value: String) {
        self = Self.safeDecode(value) ?? []
    }
}
extension Set: ExpressibleByExtendedGraphemeClusterLiteral where Element: JSON {
    public init(extendedGraphemeClusterLiteral value: String) {
        self = Self.safeDecode(value) ?? []
    }
}
extension Set: JSONSuperiorRawValues, ExpressibleByStringLiteral where Element: JSON {
    public init(stringLiteral value: String) {
        self = Self.safeDecode(value) ?? []
    }
}

extension Dictionary: ExpressibleByUnicodeScalarLiteral where Key: JSON, Value: JSON {
    public init(unicodeScalarLiteral value: String) {
        self = Self.safeDecode(value) ?? [:]
    }
}
extension Dictionary: ExpressibleByExtendedGraphemeClusterLiteral where Key: JSON, Value: JSON {
    public init(extendedGraphemeClusterLiteral value: String) {
        self = Self.safeDecode(value) ?? [:]
    }
}
extension Dictionary: JSONSuperiorRawValues, ExpressibleByStringLiteral where Key: JSON, Value: JSON {
    public init(stringLiteral value: String) {
        self = Self.safeDecode(value) ?? [:]
    }
}
