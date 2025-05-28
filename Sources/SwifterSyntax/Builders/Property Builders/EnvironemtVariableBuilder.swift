//
//  EnvironemtVariableBuilder.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/21/25.
//

///Builder for creating @Environment variables for SwiftUI
public struct EnvironemtVariableBuilder : FeildBuildable{
    var name : String
    var type : ObjectInformation
    let initialValue : InputLitteral? = nil
    let isStatic : Bool = false
    let isComputed : Bool = false
    var modifiers : [String] = []
    var attributes : [String] = ["@Environment"]
    let mutationType : MutationType = .var
    var accessLevel : AccessLevel = .private
    
    public init(name : String , type : ObjectInformation){
        self.name = name
        self.type = type
    }
    
    public func build() -> FeildType {
        .init(name: name, type: type, attributes: attributes , mutationType: mutationType, initialValue: initialValue, isComputedProperty: isComputed, modifiers: modifiers, accessLevel: accessLevel)
    }
}


public extension EnvironemtVariableBuilder{
    
    
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

