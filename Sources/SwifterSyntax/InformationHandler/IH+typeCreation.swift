//
//  IH+typeCreation.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/1/25.
//

public extension InformationHandler{
    
    static var new : InformationHandler {
        InfromationHandlerBuilder().build()
    }
    
}


public extension InformationHandler{
    
    ///Creates and insert a new ObjectInformation inside this handler
    func CreateNewType(name : String , type : ObjectType) -> ObjectInformation{
        
        let newType = ObjectInformation(type: type, info: self)
        newType.name = name
        
        self.append(newType)
        
        return newType
    }
    
}
