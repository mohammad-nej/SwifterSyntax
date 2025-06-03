////
////  KnownInfo.swift
////  SwifterSyntax
////
////  Created by MohammavDev on 6/1/25.
////
//
//
/////This type will let us differentiate between when a value is nil cause we know it's nil , or it's nil because we don't know anything about it yet
/////
/////assuming this code :
/////```swift
/////let parent = functionInfo.parent //parent == nil
/////```
/////the question is : is parent nil because we actually checked and we are certain that this value is nil? or it's nil because we haven't check yet?
//public struct KnownInfo<T> : ExpressibleByNilLiteral{
//    
//    public init(nilLiteral: ()) {
//        self = .nil
//    }
//    
//    
//    public init(value: T? = nil, isKnown: Bool) {
//        self.value = value
//        self.isKnown = isKnown
//    }
//    
//    
//    
//    public var value : T? {
//        didSet{
//            isKnown = true
//        }
//        
//    }
//    public var isKnown : Bool
//    
//    
//    ///This function will return true, if the value is known and it's nil, otherwise will return false
//    public var isReallyNil : Bool {
//        guard isKnown else { return false}
//        return value == nil
//    }
//    
//    public static var unknown : KnownInfo<T> {
//        .init(value: nil, isKnown: false)
//    }
//    
//    ///Creates a nil value which we know that it's nil
//    public static var `nil` : KnownInfo<T> {
//        .init(value: nil, isKnown: true)
//    }
//    
//    ///Creates a known value
//    public static func known(_ value : T) -> KnownInfo<T> {
//        .init(value: value, isKnown: true)
//    }
//    
//}
//
//
//extension KnownInfo : Sendable where T : Sendable{}
//
//extension KnownInfo : Equatable where T : Equatable{
//    
//    public static func == (lhs: KnownInfo<T>, rhs: KnownInfo<T>) -> Bool {
//        return lhs.isKnown && rhs.isKnown && lhs.value == rhs.value
//    }
//    
//}
//extension KnownInfo : Hashable where T : Hashable{
//    public func hash(into hasher: inout Hasher) {
//            hasher.combine(isKnown)
//            hasher.combine(value)
//    }
//}
//
//let knownString : KnownInfo<String> = nil
