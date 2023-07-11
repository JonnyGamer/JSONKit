//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 7/10/23.
//

extension JSONObject {
    func toJSON() -> String {
        json.automaticJSON()
    }
}
extension Dictionary where Key == String, Value == JSON {
    func automaticJSON() -> String {
        let foo = map({ $0.toJSON() + ":" + $1.toJSON() })
        let bar = foo.joined(separator: ", ")
        return "{" + bar + "}"
    }
}

struct Hello: JSONObject {
    var foo: Int = 1
    var json: [String : JSON] { ["foo" : foo] }
}
