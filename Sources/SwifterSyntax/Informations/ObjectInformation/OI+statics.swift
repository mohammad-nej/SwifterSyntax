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


extension ObjectInformation {
    
    /// Convince method to infer your type from a given string, can be use to infer most common swift types like String, Bool, Int
    ///  arrays and optionals created from these types and much more. will return nil if inferring is failed
    /// - Parameters:
    ///   - value: your type name
    ///   - info: Use this informationHandler to search for your requested type
    /// - Returns: type of your variable if found, otherwise nil
    public static func infer(from value : String, using info : InformationHandler ) -> ObjectInformation?{
      
        info.find(value)
    }
    
    
    /// Tries to infer the type based on the `string` parameter, if it fails it will create a new  type and return it
    /// - Parameters:
    ///   - string: "name of the type we are looking for"
    ///   - type: "Type of the object that will be created if it fails to infer the type "
    ///   - info: "informationHandler object that is used to infer the type"
    /// - Returns: inferred type if possible, otherwise will create a new type
    public static func fromString(_ string : String, type : ObjectType = .struct , using info : InformationHandler ) -> ObjectInformation {
        if let infered = infer(from: string,using: info) {
            return infered
        }
        
        let newObject = ObjectInformation(type: type,info: info)
        newObject.name = string
        newObject.informationHandler = info
        info.objects.upsert(newObject)
        return newObject
    }
}
