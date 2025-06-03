//
//  ObjectType.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/13/25.
//


///Type of the type :D , struct , class, enum ,....
public enum ObjectType : String ,Sendable, CaseIterable , Identifiable, CodeGeneratable {
    public var id : Self { self}
    public var code : String {
        guard self != .unknown else {
            return "Unkonow type ! "
        }
        return rawValue
    }
    case `struct`,`class`,`enum`, `actor`,`protocol`
    
    ///when it's not explicitly mentioned
    case unknown
}



///Mutation type of a variable : var or let ?
public enum MutationType : String ,Sendable, CaseIterable , Identifiable, CodeGeneratable {
    public var id: Self { self }
    case `var` , `let`
    
    public var code : String {
        rawValue
    }
}




