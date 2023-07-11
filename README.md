# JSONKit
A friendly way to encode and decode JSON in Swift

---

With this package, various built in types conform to the `JSON` protocol.

```swift
let encodedArray: String = [1, 2, 3].encode() // "[1, 2, 3]"
let decodedArray: [Int] = .decode(encodedArray) // [1, 2, 3]
```
