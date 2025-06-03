//
//  FieldBuilder.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/21/25.
//


public protocol FeildBuildable {
    
  
    init(name : String , type : ObjectInformation)
    
    func build() -> FeildType
}



///Builder capable of creating an internal Variable for you
public struct FieldBuilder : FeildBuildable  {
    
    
    
    
    
    var name : String
    var type : ObjectInformation
    var initialValue : InputLitteral?
    var isStatic : Bool = false
    var isComputed : Bool = false
    var modifiers : [String] = []
    var attributes : [String] = []
    var mutationType : MutationType = .var
    var accessLevel : AccessLevel = .internal
 
    
    public static func variable(name : String , type : ObjectInformation) -> Self {
        .init(name: name, type: type)
    }
    
    public init(name : String , type : ObjectInformation){
        self.name = name
        self.type = type
    }
    
    public func build() -> FeildType {
        .init(name: name, type: type, attributes: attributes , mutationType: mutationType, initialValue: initialValue, isComputedProperty: isComputed, modifiers: modifiers, accessLevel: accessLevel)
    }
}

public extension FeildBuildable where Self == EnvironemtVariableBuilder {
    static func environment(name : String , type : ObjectInformation) -> Self {
        .init(name: name, type: type)
    }
}



public extension FieldBuilder {
    
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
    func initialValue(_ initialValue : InputLitteral?) -> Self {
        var copy = self
        copy.initialValue = initialValue
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
    func isComputed(_ isComputed : Bool) -> Self {
        var copy = self
        copy.isComputed = isComputed
        copy.mutationType = .var
        copy.initialValue = nil
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
    func mutationType(_ mutationType : MutationType) -> Self {
        var copy = self
        copy.mutationType = mutationType
        return copy
    }
    func accessLevel(_ accessLevel : AccessLevel) -> Self {
        var copy = self
        copy.accessLevel = accessLevel
        return copy
    }
}
