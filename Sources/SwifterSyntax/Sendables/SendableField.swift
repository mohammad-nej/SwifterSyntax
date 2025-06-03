//
//  SendableField.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/26/25.
//
import Foundation

///Sendable type for FeildType , useful when you want to send FieldType across thread boundaries
///
///You can use .sendable property on `FeildType` to create an instance of this type
///```swift
///let variable = FeildType.var(name:"name",type:info.string,initialValue:"Mohammad")
/////do your stuff here
/////...
///let sendableField = variable.sendable
///```
public struct SendableField : Sendable,CodeGeneratable , Identifiable  , Hashable , Equatable{
    
    init(from field : FeildType) {
        self.id = field.id
        self.name = field.name
        self.attributes = .init(field.attributes)
        self.modifiers = .init(field.modifiers)
        self.mutationType = field.mutationType
        self.isComputedProperty = field.isComputedProperty
        self.initialValue = field.initialValue
        if let type = field.type?.sendable{
            self._type = [type]
        }else{
            self._type = []
        }
        self.code = field.code
        self.isArray = field.isArray
        self.isOptional = field.isOptional
        self.isNil = field.isNil
        self.isStatic = field.isStatic
        self.accessLevel = field.accessLevel
        self.isStateVariable = field.isStateVariable
        
    }
    
    
    public let id : UniqueID
    
    ///name of the variable
    public let name : String
    
    //because each ObjectInformation contains FieldType and each FieldType contains ObjectInformation
    //this will create infinite recursion when converting into struct, thus we are going around it by passing type into an array first.
    private let _type : [SendableObjectInformation]
    
    ///Type of this variable, can be nil if fails to infer the type
    public var type : SendableObjectInformation? {
        _type.first
    }
    
    public let attributes : [String]
    
    /// var or let ?
    public let mutationType : MutationType
    /// InitialValue of this variable if provided
    public let initialValue : InputLitteral?
    
    public let isComputedProperty : Bool
    
    ///modifiers attached to this variable e.g. static , lazy , ...
    public let modifiers : [String]
    
    ///Detects if this variable is an array or not ? returns nil if the type is nil
    public let isArray : Bool?
    ///Detects if this variable is an optional or not ? returns nil if the type is nil
    public let isOptional : Bool?
    ///Generate code for declaring this variable
    public let code : String
    
    public let isStatic : Bool
    
    ///public , private , ...
    public let accessLevel : AccessLevel
    
    public let isNil : Bool
    
    ///Detects if variable is a SwiftUI @State/@StateObject variable or not?
    public let isStateVariable : Bool
}

extension SendableField {
    public static func == (lhs: SendableField, rhs: SendableField) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
