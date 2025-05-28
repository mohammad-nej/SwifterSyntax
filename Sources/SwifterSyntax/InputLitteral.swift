//
//  InputLitteral.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/26/25.
//

///Provides information about the initialValue of variables in swift code
///
public enum InputLitteral : Sendable , ExpressibleByStringLiteral , ExpressibleByBooleanLiteral , ExpressibleByIntegerLiteral , ExpressibleByFloatLiteral , CodeGeneratable {
    
    
    public init(booleanLiteral value: Bool) {
        if value == true {
            self = .true
        }else{
            self = .false
        }
    }
    
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
    
    public init(floatLiteral value: Double) {
        self = .double(value)
    }
    
    
    
    public typealias StringLiteralType = String
    
    public typealias BooleanLiteralType = Bool
    
    public typealias IntegerLiteralType = Int
    
    public typealias FloatLiteralType = Double
    
    
    ///Creates literal from stringLitteral
    /// - Note: this function will automatically do conversions for you. for example it will convert "true"
    /// to .true , or "nil" to .nil
    ///
    /// if that's not what you want use `.init(exact:String)` initializer which doesn't do any conversion
    public init(stringLiteral value: String) {
        if value == "true" {
            self = .true
        }else if value == "false" {
            self = .false
        }else if value.hasPrefix(("[")) && value.hasSuffix(("]")) {
            self = .array(value)
        }else if value == "nil"{
            self = .nil
        }
        else{
            self = .string("\(value)")
        }
    }
    
    ///Creates litteral from string
    /// - Note: this function will automatically do conversions for you. for example it will convert "true"
    /// to .true , or "nil" to .nil
    ///
    ///```swift
    ///var value = "true"
    ///let litteral : InputLitteral = .init(from: value)
    /////litteral -> .true
    ///```
    /// if that's not what you want, use `.init(exact:String)` initializer which doesn't do any conversion
    public init(from value : String){
        if value == "true" {
            self = .true
        }else if value == "false" {
            self = .false
        }else if value.hasPrefix(("[")) && value.hasSuffix(("]")) {
            self = .array(value)
        }else if value == "nil"{
            self = .nil
        }
        else{
            self = .string("\(value)")
        }
    }
    
    ///This initializer will not do any automatic conversions, will always create a .string(String) version for you
    ///
    ///This can be useful if you want to have a string variable with initialValue of "nil"
    ///```swift
    ///var name : String = "nil"
    ///
    ///let litteral : InputLitteral = .init(exact: name)
    /////litteral -> .string("nil")
    ///
    ///let litteral2 : InputLitteral = .init(from : name)
    /////litteral -> .nil
    ///```
    ///
    public init(exact value : String){
        self = .string(value)
    }
    
    case `nil`, `true`,`false` , string(String) , double(Double) , int(Int) , array(String)
    
    ///Exact value entered by the user
    public var value : String {
        switch self {
        case .nil:
            return "nil"
        case .array(let value):
            
            return "\(value)"
            
        case .true:
            return "true"
        case .false:
            return "false"
        case .string(let value):
            return "\(value)"
        case .double(let value):
            return "\(value)"
        case .int(let value):
            return "\(value)"
            
        }
    }
    
    ///Value useful to be used in swift code
    ///
    ///For example all Strings will be inside " " in this property
    ///
    public var code : String {
        switch self {
        case .nil:
            return "nil"
        case .array(let value):
            if value.starts(with: ("[")) && value.hasSuffix(("]")) {
                return value
            }else{
                return "[\(value)]"
            }
        case .true:
            return "true"
        case .false:
            return "false"
        case .string(let value):
            if value.starts(with: ("\"")) && value.hasSuffix(("\"")) {
                return value
            }else{
                return "\"\(value)\""
            }
        case .double(let value):
            return "\(value)"
        case .int(let value):
            return "\(value)"
            
        }
    }
    
}
extension InputLitteral : Equatable {
    
    public static func == (lhs: InputLitteral, rhs: InputLitteral) -> Bool {
        return lhs.code == rhs.code
    }
}
public extension InputLitteral {
    static func from(_ string : String) -> InputLitteral{
        .init(from: string)
    }
}

public extension String {
    var litteral : InputLitteral{
        .from(self)
    }
}

public extension Int {
    var litteral : InputLitteral{
        .int(self)
    }
}

public extension Float {
    var litteral : InputLitteral{
        .double(Double(self))
    }
}

public extension Double {
    var litteral : InputLitteral{
        .double(self)
    }
}
public extension Bool {
    var litteral : InputLitteral{
        self ? .true : .false
    }
}


