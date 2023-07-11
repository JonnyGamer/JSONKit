# JSONKit
A friendly way to encode and decode JSON in Swift

---

With this package, various built-in types automatically conform to the `JSON` protocol. (You're welcome)

```swift
let encodedArray: String = [1, 2, 3].encode() // "[1, 2, 3]"
let decodedArray: [Int] = .decode(encodedArray) // [1, 2, 3]
```

---

# Store Custom Objects as JSON
Here's an example of using a complex recursive object, and storing it as json. Your opportunities are endless, so to speak.
```swift
struct Wow: JSONObject {
    var a = "Hello"
    var b : Int?
    var c : [Wow] = []

    // Here is where your variables will be jsonified
    var json: [String : JSON] { ["a":a, "b":b, "c":c] }
}
        
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
```

---

# Store enums as JSON

```swift
enum A: String, JSON {
    case a,b,c
}

let encodedEnum: String = A.a.encode() // "a"
let decodedEnum: A = .decode(encodedArray) // a
```

---
# Bro, there's these complicated enums, too

You may encode and decode these kinds of enums, as well. It doth require a little bit more setup than ordinary enums

```swift
enum ThisIsSoCool: JSONEnum, Equatable {
    case a
    case b(Int)
    case c(String)
    case d(Int, Int)
    case e(Int, [Int], [[Int]], [Self], Bool)
    indirect case f(Self)
    case g(A)
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
        "i" : { .i(P._) }
    ]
}
```

