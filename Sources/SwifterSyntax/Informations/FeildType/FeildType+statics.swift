//
//  FeildType+statics.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/29/25.
//

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
    static func computedProperty(name : String , type : ObjectInformation,source : String? = nil) -> FeildType {
        var prop = ComputedPropertyBuilder(name: name, type: type)
        if let source{
            prop = prop.sourceCode(source)
        }
        return prop.build()
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

