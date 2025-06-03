//
//  ComputedPropertyBuilder.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/21/25.
//

///Creates an internal computed property by default
public struct ComputedPropertyBuilder : FeildBuildable{
    var name : String
    var type : ObjectInformation
    
    ///always nil , computed properties can't have initialValue
    let  initialValue : InputLitteral? = nil
    var isStatic : Bool = false
    let isComputed : Bool = true
    var innerSourceCode : String? = nil
    var modifiers : [String] = []
    var attributes : [String] = []
    let mutationType : MutationType = .var
    var accessLevel : AccessLevel = .unknown
 
    //Creates a computed property with the given types for you
    public static func computedProperty(name : String , type : ObjectInformation , sourceCode : String? = nil) -> Self {
        var feild = ComputedPropertyBuilder(name: name, type: type)
        feild.innerSourceCode = sourceCode
        return feild
    }
    
    public init(name : String , type : ObjectInformation){
        self.name = name
        self.type = type
    }
    
    public func build() -> FeildType {
        let feild : FeildType = .init(name: name, type: type, attributes: attributes , mutationType: mutationType, initialValue: initialValue, isComputedProperty: isComputed, modifiers: modifiers, accessLevel: accessLevel)
        feild.innerSourceCode = innerSourceCode
        return feild
    }
    
    
}
public extension ComputedPropertyBuilder {
    
    func name(_ name : String) -> Self {
        var copy = self
        copy.name = name
        return copy
    }
    func type(_ type : ObjectInformation) -> Self {
        var copy = self
        copy.type = type
        return copy
    }
  
    func sourceCode(_ code : String) -> Self{
        var copy = self
        copy.innerSourceCode = code
        return copy
    }
    func isStatic(_ isStatic : Bool) -> Self {
        var copy = self
        if !copy.modifiers.contains("static"){
            copy.modifiers.append("static")
        }
        copy.isStatic = isStatic
        return copy
    }
    func modifiers(_ modifiers : [String]) -> Self {
        var copy = self
        copy.modifiers = modifiers
        return copy
    }
    func attributes(_ attributes : [String]) -> Self {
        var copy = self
        copy.attributes = attributes
        return copy
    }
 
    func accessLevel(_ accessLevel : AccessLevel) -> Self {
        var copy = self
        copy.accessLevel = accessLevel
        return copy
    }
}
