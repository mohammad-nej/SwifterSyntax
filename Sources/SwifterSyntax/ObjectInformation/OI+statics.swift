//
//  OI+statics.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/27/25.
//


//for connivance
public extension ObjectInformation {
   
    ///Creates an struct with your given name
    static func `struct`(_ name : String,using info : InformationHandler) -> ObjectInformation {
        let object : ObjectInformation = .init(type: .struct, info: info)
        object.name = name
        return object
    }
    
    ///Creates a class with your given name
    static func `class`(_ name : String,using info : InformationHandler) -> ObjectInformation {
        let object : ObjectInformation = .init(type: .class,info:info)
        object.name = name
        return object
    }
    
    ///Creates an actor with your given name
    static func `actor`(_ name : String,using info : InformationHandler) -> ObjectInformation {
        let object : ObjectInformation = .init(type: .actor,info:info)
        object.name = name
        return object
    }
    
    ///Creates an enum with your given name
    static func `enum`(_ name : String,using info : InformationHandler) -> ObjectInformation {
        let object : ObjectInformation = .init(type: .enum,info:info)
        object.name = name
        return object
    }

    ///Creates a protocol with your given name
    static func `protocol`(_ name : String,using info : InformationHandler) -> ObjectInformation {
        let object : ObjectInformation = .init(type: .protocol,info:info)
        object.name = name
        return object
    }
    
    //Use this when you don't care about the type or anything else
    static func `literal`(_ name : String,using info : InformationHandler) -> ObjectInformation {
        let object : ObjectInformation = .init(type: .struct,info:info)
        object.name = name
        return object
    }
}
