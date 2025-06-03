//
//  FeildType+computed.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/29/25.
//

 extension FeildType{
    
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
     
    
     ///Indicates whether this variable is a global variabe or not ?
     public var isGlobal : Bool {
         return parentType == nil
     }
     
     /// A Sendable struct version of this object, can be used to send across multiple threads
     public var sendable : SendableField {
         .init(from: self)
     }
     

     ///Indicates whether it's an array or not? returns nil if type is unknown
     public var isArray : Bool? {
         guard let type else { return nil}
         return type.isArray
     }
     
     public var isStatic : Bool {
         return modifiers.contains("static")
     }
     
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
