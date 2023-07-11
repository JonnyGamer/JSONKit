import XCTest
@testable import JSONKit

final class JSONKitTests: XCTestCase {
    func testAutoJSON() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        // Integer Tests
        XCTAssertEqual(1, .decode(1.encode()))
        XCTAssertEqual(-1, .decode((-1).encode()))
        XCTAssertEqual(0, .decode(Int.zero.encode()))
        XCTAssertEqual(Int.max, .decode(Int.max.encode()))
        XCTAssertEqual(Int.min, .decode(Int.min.encode()))
        
        // UInts
        XCTAssertEqual(1, .decode(UInt8(1).encode()))
        XCTAssertEqual(1, .decode(UInt16(1).encode()))
        XCTAssertEqual(1, .decode(UInt32(1).encode()))
        XCTAssertEqual(1, .decode(UInt64(1).encode()))
        
        // Other Kinds
        XCTAssertEqual(1.0, .decode(1.0.encode()))
        XCTAssertEqual(1.0, .decode(Float(1.0).encode()))
        XCTAssertEqual(true, .decode(true.encode()))
        XCTAssertEqual(false, .decode(false.encode()))
        
        // Strings
        XCTAssertEqual("", .decode("".encode()))
        XCTAssertEqual("\'", .decode("\'".encode()))
        XCTAssertEqual("\"", .decode("\"".encode()))
        XCTAssertEqual("\\", .decode("\\".encode()))
        XCTAssertEqual("\n", .decode("\n".encode()))
        XCTAssertEqual("\t", .decode("\t".encode()))
        XCTAssertEqual("\r", .decode("\r".encode()))
        XCTAssertEqual("A", .decode("\u{0041}".encode()))
        XCTAssertEqual("Hello, World!", .decode("Hello, World!".encode()))
        
        // Arrays
        XCTAssertEqual([Int](), .decode([Int]().encode()))
        XCTAssertEqual([1,2,3,4,5], .decode([1,2,3,4,5].encode()))
        XCTAssertEqual([[1],[2],[3]], .decode([[1],[2],[3]].encode()))
        XCTAssertEqual([[[[[[1]]]]]], .decode([[[[[[1]]]]]].encode()))
        XCTAssertEqual(["Hello"], .decode(["Hello"].encode()))
        XCTAssertEqual(["[\"Oh goodness\"]"], .decode(["[\"Oh goodness\"]"].encode()))
        // Sets
        XCTAssertEqual(Set([1]), .decode([1].encode()))
        XCTAssertEqual(Set([1]), .decode(Array([1,1,1,1,1,1]).encode()))
        // Dictionaries
        XCTAssertEqual([1:1], .decode([1:1].encode()))
        XCTAssertEqual(["foo":1], .decode(["foo":1].encode()))
        XCTAssertEqual([[1:1]:[1:1]], .decode([[1:1]:[1:1]].encode()))
        struct oboy: JSONObject, Hashable {
            var a: Int = 1
            var json: [String : JSON] { ["a":a] }
        }
        XCTAssertEqual([oboy():1], .decode([oboy():1].encode()))
    }
    
    func testEnums() {
        
        enum A: String, JSON {
            case a,b,c
        }
        XCTAssertEqual(A.a, .decode(A.a.encode()))
        XCTAssertEqual(A.b, .decode(A.b.encode()))
        XCTAssertEqual(A.c, .decode(A.c.encode()))
        
        enum B: Int, JSON {
            case a=0,b,c
        }
        XCTAssertEqual(B.a, .decode(B.a.encode()))
        XCTAssertEqual(B.b, .decode(B.b.encode()))
        XCTAssertEqual(B.c, .decode(B.c.encode()))
        
        enum C: Bool, JSON {
            case a=true
            case b=false
        }
        XCTAssertEqual(C.a, .decode(C.a.encode()))
        XCTAssertEqual(C.b, .decode(C.b.encode()))
        
        enum D: [Int], JSONSuperiorRawValues {
            case a="[1]"
            case b="[0,0,0,0,0]"
            case c="[0, 0, 0, 0, 0]"
        }
        XCTAssertEqual(D.b, D.c)
        XCTAssertEqual(D.a, .decode(D.a.encode()))
        XCTAssertEqual(D.c, .decode(D.b.encode()))
        
        enum E: Set<Int>, JSONSuperiorRawValues {
            case a="[1]"
            case b="[0,0,0,0,0]"
            case c="[0]"
        }
        XCTAssertEqual(E.b, E.c)
        XCTAssertEqual(E.a, .decode(E.a.encode()))
        XCTAssertEqual(E.c, .decode(E.b.encode()))
        
        enum F: [Int:Int], JSONSuperiorRawValues {
            case a="[1:1]"
            case b="[:]"
            case c="[ : ]"
        }
        XCTAssertEqual(F.b, F.c)
        XCTAssertEqual(F.a, .decode(F.a.encode()))
        XCTAssertEqual(F.c, .decode(F.b.encode()))
        
        
        struct oboy: JSONObject, Hashable, Equatable {
            var a: Int = 1
            var json: [String : JSON] { ["a":a] }
        }
        // TODO: Allow Associated Values of type JSONSuperiorRawValues
        enum G: JSONEnum, Equatable {
            case a
            case b(Int)
            case c(String)
            case d(Int, Int)
            case e(Int, [Int], [[Int]], [Self], Bool)
            indirect case f(Self)
            case g(A)
            // case h(F)
            case i(oboy)
            
            // Convert the things INTO JSON
            func allCases(_ run: AssociatedValues) {
                switch self {
                case .a: run()
                case let .b(i): run(i)
                case let .c(i): run(i)
                case let .d(i, j): run(i, j)
                case let .e(i, j, k, l, m): run(i, j, k, l, m)
                case let .f(i): run(i)
                case let .g(i): run(i)
                // case let .h(i): run(i)
                case let .i(i): run(i)
                }
            }
            // Help specify the types when turning JSON back into Swift
            static var decoding: [String : () -> Self] = [
                "a" : { .a },
                "b" : { .b(P._) },
                "c" : { .c(P._) },
                "d" : { .d(P._, P._) },
                "e" : { .e(P._, P._, P._, P._, P._) },
                "f" : { .f(P._) },
                "g" : { .g(P._) },
                // "h" : { .h(dd()) },
                "i" : { .i(P._) }
            ]
        }
        
        XCTAssertEqual(G.a, .decode(G.a.encode()))
        XCTAssertEqual(G.b(1), .decode(G.b(1).encode()))
        XCTAssertEqual(G.c(""), .decode(G.c("").encode()))
        XCTAssertEqual(G.d(1, 0), .decode(G.d(1, 0).encode()))
        XCTAssertEqual(G.e(1, [1], [[1]], [.a], true), .decode(G.e(1, [1], [[1]], [.a], true).encode()))
        XCTAssertEqual(G.f(.f(.f(.f(.f(.a))))), .decode(G.f(.f(.f(.f(.f(.a))))).encode()))
        XCTAssertEqual(G.g(.a), .decode(G.g(.a).encode()))
        // XCTAssertEqual(G.h(.a), .decode(G.h(.a).encode()))
        XCTAssertEqual(G.i(oboy()), .decode(G.i(oboy()).encode()))
    }
    
    func testTheStrangeBoy() {
        // TODO: Failing rn, gotta test this some more
//        struct oboy2: JSONSuperiorObject {
//            var a: Int = 1
//            var json: [String : JSON] { ["a":a] }
//        }
//        enum H: oboy2, JSONSuperiorRawValues {
//
//            typealias RawValue = oboy2
//            func toJSON() -> String {
//                return rawValue.rawValue
//            }
//            func prettyJSON(_ indent: Int) -> String {
//                return RawValue.init(rawValue: rawValue.rawValue).prettyJSON(0)
//            }
//
//            case a=#"{"a":1}"#
//        }
//        print(H.a.encode())
//        //XCTAssertEqual(H.a, .decode(H.a.encode()))
    }
    
    func testObjects() {
        
        struct Wow: JSONObject, Equatable {
            var a = "Hello"
            var b : Int? = nil
            var c : [Wow] = []
            var json: [String : JSON] { ["a":a, "b":b, "c":c] }
        }
        
        XCTAssertEqual(Wow(), .decode(Wow().encode()))
        
        var foo = Wow()
        foo.b = 1
        foo.c = [Wow(), Wow()]
        print(foo.encodePretty()) // {"a":"Hello" ... }
        
        let bar = """
        {
        "a" : "Hello",
          "b" : 1,
          "c" : [
            {
              "c" : [],
              "a" : "Hello"
            },
            {
              "a" : "Hello",
              "c" : []
            }
          ]
        }
        """

        let decodedObject: Wow = .decode(bar)
        XCTAssertEqual(foo, decodedObject)
        
        enum A: String, JSON {
            case a,b,c
        }

        let encodedEnum: String = A.a.encode() // "[1, 2, 3]"
        print(encodedEnum)
        let decodedEnum: A = .decode(encodedEnum) // [1, 2, 3]
        print(decodedEnum)
        XCTAssertEqual(A.a, decodedEnum)
    }
}
