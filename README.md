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
  "b" : 1
  "c" : [
    {
      "a" : "Hello"
      "c" : [],
    },
    {
      "a" : "Hello"
      "c" : [],
    }
  ],
}
"""

let decodedObject: Wow = .decode(bar)
```


