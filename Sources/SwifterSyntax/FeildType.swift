//
//  FeildType.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/15/25.
//

import Foundation

public final class FeildType :  SendableCreatable, Identifiable ,CodeGeneratable , Hashable , Equatable {
   

    
    public let id : UUID = UUID()
    
    ///Name of the variable
    public let name : String
    
    ///typed of variable like Int,String,...
    public weak var type : ObjectInformation?
    
    /// A Sendable struct version of this object, can be used to send across multiple threads
    public var sendable : SendableField {
        .init(from: self)
    }
    
    ///macros like @Observable or @State , ...
    public var attributes : [String] = []
    
    ///var , let
    public var mutationType : MutationType
    
    ///Determines if a variables is swiftUI environment variable or not?
    public var isEnvironmentVariable : Bool {
        return attributes.contains("@Environment")
    }
    
    public var informationHandler : InformationHandler? {
        guard let info = type?.informationHandler else { return nil}
        return info
    }
    
    ///indicates whether it's optional  or not ? returns nil if type is unknown
    public var isOptional : Bool? {
        guard let type else { return nil}
        return type.isOptional
    }
    
    ///initial value provided when declaring the variable.
    ///Some variables might not have initialValue e.g. computed properties or the initialValue
    ///might not be explicit for example in SwiftUI all EnvironmentKeys has a default value, but it's not explicitly written in text
    /// - Warning: For Optional variables if the initialValue is nil , it will be specified by "nil" string, if this variable value is nil it means that
    /// initialValue was undetectable. e.g. computed properties can't have initialValue.
    /// - Note: Use `isNil` to detect if variable initialValue is nil or not.
    public let initialValue : InputLitteral?
    
    ///indicates whether it's a computed property or not ?
    public  var isComputedProperty : Bool
    
    ///Indicates whether it's an array or not? returns nil if type is unknown
    public var isArray : Bool? {
        guard let type else { return nil}
        return type.isArray
    }
    
    
    
    
    ///static , private ,...
    public var modifiers : [String]
    
    public var isStatic : Bool {
        return modifiers.contains("static")
    }
    
    public var code : String {
        guard let type else {
            return "Error: Type of variable \(name) is unknown"
        }
        guard !isComputedProperty else {
            return "Error: Code Generation is not supported for computed properties yet. property name : \(name)"
        }
    
        
        if isEnvironmentVariable{
            return "@Environment(\(type.name).self) \(accessLevel.code) var \(name)"
        }
        
        var code = ""
        if attributes.isEmpty == false{
            code += attributes.joined(separator: " ") + " "
        }
        if modifiers.isEmpty == false{
            code += modifiers.joined(separator: " ") + " "
        }
        
        let accessLevelCode =  accessLevel.code
        if accessLevelCode.isEmpty == false{
            code += accessLevelCode + " "
        }
        
        code += mutationType.code
        code += " \(name) : \(type.name)"
        
        if let initialValue = self.initialValue{
            let valueCode =  " = " + initialValue.code
            code += valueCode
        }
        return code
    }
    ///private,public,....
    public var accessLevel : AccessLevel
    
    public init(name: String, type: ObjectInformation?, attributes: [String], mutationType: MutationType, initialValue: InputLitteral?, isComputedProperty: Bool, modifiers: [String], accessLevel: AccessLevel) {
        self.name = name
        self.type = type
        
        self.attributes = attributes
        self.mutationType = mutationType
        self.initialValue = initialValue
        self.isComputedProperty = isComputedProperty
        self.modifiers = modifiers
        self.accessLevel = accessLevel
    }
}

public extension FeildType{
    static func == (lhs: FeildType , rhs: FeildType) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
public extension FeildType {
    
    ///Creates a static variable for you
    static func `static`(name : String , type : ObjectInformation,initialValue : String? = nil) -> FeildType {
        StaticFieldBuilder(name: name, type: type).build()
    }
    
    ///Creates a swiftUI @State private var name : type = initialValue  property 
    static func stateVariable(name : String , type : ObjectInformation,initialValue : InputLitteral?) -> FeildType {
        StateVariableBuilder(name: name, type: type).initialValue(initialValue).build()
    }
    
    ///Creates a computed property
    static func computedProperty(name : String , type : ObjectInformation) -> FeildType {
        ComputedPropertyBuilder(name: name, type: type).build()
    }
    
    ///Creates a @Environment(type.self) private var .... variable for you
    static func environment(name : String , type : ObjectInformation) -> FeildType {
        EnvironemtVariableBuilder(name: name, type: type).build()
    }
    
    ///Creates a var variable for you: var name : type = initialValue
    static func `var`(name : String , type : ObjectInformation,initialValue : InputLitteral? = nil) -> FeildType {
        FieldBuilder(name: name, type: type).mutationType(.var).initialValue(initialValue).build()
    }
    
    ///Creates an array of your given type for you
    static func array(name : String , type : ObjectInformation,initialValue : InputLitteral = "[]" ) -> FeildType?{
        guard let array = type.array else { return Optional<FeildType>.none}
        return FieldBuilder(name: name, type: array).mutationType(.var).initialValue(initialValue).build()
    }
    
    ///Create an Optional type for you :  var name : String? = nil , default initialValue is nil
    static func optional(name : String , type : ObjectInformation,initialValue : InputLitteral = .nil) -> FeildType?{
        guard let optional = type.optional else { return Optional<FeildType>.none}
        return FieldBuilder(name: name, type: optional ).mutationType(.var) .initialValue(initialValue).build()
    }
    
    ///Creates a let variable for you : let name : type = initialValue
    static func `let`(name : String , type : ObjectInformation, initialValue : InputLitteral? = nil) -> FeildType {
        FieldBuilder(name: name, type: type).mutationType(.let).initialValue(initialValue).build()
    }
}

extension FeildType {
    public var isStateVariable : Bool {
        for attribute in self.attributes {
            return attribute == "@State" || attribute == "@StateObject"
        }
        return false
    }
    public var isNil : Bool {
        return initialValue == .nil
    }
    
}
