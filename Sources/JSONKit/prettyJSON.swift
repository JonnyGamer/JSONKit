//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 7/10/23.
//

func tabs(_ n: Int) -> String {
    return String.init(repeating: .tab, count: n)
}
extension String {
    static var tab: String = "  "
    func deleteBeginnign(_ str: String) -> String {
        var foo = self
        while foo.hasPrefix(str) {
            foo.removeFirst(str.count)
        }
        return foo
    }
}


extension JSON {
    public func encodePretty() -> String {
        return prettyJSON(0)
    }
}

extension AutoJSON {
    public func prettyJSON(_ indent: Int) -> String {
        return tabs(indent) + toJSON()
    }
}

extension String {
    public func prettyJSON(_ indent: Int) -> String {
        return tabs(indent) + toJSON()
    }
}

extension Array where Element: JSON {
    public func prettyJSON(_ indent: Int) -> String {
        if isEmpty { return tabs(indent) + "[]" }
        return tabs(indent) + "[\n" + map({ $0.prettyJSON(indent+1) }).joined(separator: ",\n") + "\n" + tabs(indent) + "]"
    }
}

extension Set where Element: JSON {
    public func prettyJSON(_ indent: Int) -> String {
        if isEmpty { return tabs(indent) + "[]" }
        return tabs(indent) + "[\n" + map({ $0.prettyJSON(indent+1) }).joined(separator: ",\n") + "\n" + tabs(indent) + "]"
    }
}

extension Dictionary where Key: JSON, Value: JSON {
    public func prettyJSON(_ indent: Int) -> String {
        if let a = self as? StringDict {
            return a.toPrettyJSON2(indent)
        } else if let a = self as? EasyDict {
            return a.toPrettyJSON2(indent)
        }
        return toPrettyJSON2(indent)
    }
}

extension Dictionary where Key: AutoJSON, Value: JSON {
    public func toPrettyJSON2(_ indent: Int) -> String {
        if isEmpty { return tabs(indent) + "{}" }
        let quote = #"""#
        let foo = map({ tabs(indent+1) + quote + $0.toJSON() + quote + " : " + $1.prettyJSON(indent+1).deleteBeginnign(.tab) })
        let bar = foo.joined(separator: ",\n")
        return tabs(indent) + "{\n" + bar + "\n" + tabs(indent) + "}"
    }
}
extension Dictionary where Key == String, Value: JSON {
    public func toPrettyJSON2(_ indent: Int) -> String {
        if isEmpty { return tabs(indent) + "{}" }
        let foo = map({ tabs(indent+1) + $0.toJSON() + " : " + $1.prettyJSON(indent+1).deleteBeginnign(.tab) })
        let bar = foo.joined(separator: ",\n")
        return tabs(indent) + "{\n" + bar + "\n" + tabs(indent) + "}"
    }
}
extension Dictionary where Key: JSON, Value: JSON {
    public func toPrettyJSON2(_ indent: Int) -> String {
        if isEmpty { return tabs(indent) + "[]" }
        let foo = map({ tabs(indent+1) + $0.prettyJSON(indent+1).deleteBeginnign(.tab) + ",\n" + tabs(indent+1) + $1.prettyJSON(indent+1).deleteBeginnign(.tab) })
        let bar = foo.joined(separator: ",\n")
        return tabs(indent) + "[\n" + bar + "\n" + tabs(indent) + "]"
    }
}

extension Optional where Wrapped: JSON {
    public func prettyJSON(_ indent: Int) -> String {
        return tabs(indent) + toJSON()
    }
}


extension JSONEnum {
    public func superEncodePretty(_ name: String, values: [JSON], indent: Int) -> String {
        if values.isEmpty {
            return tabs(indent) + "{\n" + tabs(indent+1) + "\"\(name)\" : null" + "\n" + tabs(indent) + "}"
        }
        if values.count == 1 {
            return tabs(indent) + "{\n" + tabs(indent+1) + "\"\(name)\" : " + values[0].prettyJSON(indent+1).deleteBeginnign(.tab) + "\n" + tabs(indent) + "}"
        }
        let wo = values.enumerated().map({ i, j -> String in
            return tabs(indent+1) + "\"\(name)-\(i+1)\" : " + j.prettyJSON(indent+2).deleteBeginnign(.tab)
            //return "\"\(name)-\(i+1)\": \(j.toJSON())"
        })
        return tabs(indent) + "{\n" + wo.joined(separator: ",\n") + "\n" + tabs(indent) + "}"
        //return "{" + wo.joined(separator: ", ") + "}"
    }
    public func prettyJSON(_ intend: Int) -> String {
        let name = String("\(self)".split(separator: "(")[0])
        
        var found = ""
        allCases { (foo: JSON...) in
            found = superEncodePretty(name, values: foo, indent: intend)
        }
        return found
    }
}

extension JSONObject {
    public func prettyJSON(_ indent: Int) -> String {
        json.automaticPrettyJSON(indent)
    }
}
extension Dictionary where Key == String, Value == JSON {
    public func automaticPrettyJSON(_ indent: Int) -> String {
        var foo = map({ tabs(indent+1) + $0.toJSON() + " : " + $1.prettyJSON(indent+1).deleteBeginnign(.tab) })
        foo = foo.filter({ !$0.hasSuffix("null") }) // Remove 'nulls' from JSON, not necessary lol
        if foo.isEmpty {
            return tabs(indent) + "{}"
        }
        let bar = foo.joined(separator: ",\n")
        return tabs(indent) + "{\n" + bar + "\n" + tabs(indent) + "}"
    }
}


extension JSON where Self: RawRepresentable, RawValue: JSON {
    public func prettyJSON(_ indent: Int) -> String {
        return tabs(indent) + toJSON()
    }
}
