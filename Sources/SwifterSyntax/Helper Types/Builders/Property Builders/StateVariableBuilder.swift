//
//  StateVariable.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/21/25.
//

///Builder for creating a SwiftUI @State private var for you
public struct StateVariableBuilder : FeildBuildable{
        
    var name : String
    var type : ObjectInformation
    var initialValue : InputLitteral?
    let isStatic : Bool = false
    let isComputed : Bool = false
    var modifiers : [String] = []
    var attributes : [String] = ["@State"]
    let mutationType : MutationType = .var
    var accessLevel : AccessLevel = .private
 
    ///Creates a @State variable for you
    public static func stateVariable(name : String , type : ObjectInformation) -> Self {
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
public extension StateVariableBuilder {
    
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
