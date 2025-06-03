//
//  IH+isFunctions.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/1/25.
//

extension InformationHandler{
    
    public func isClass(_ typeName : String) throws -> Bool {
        let findObject = find(typeName)
        
        guard let findObject else { throw FindingError.notFound}
        return findObject.type == .class
    }
    
    public func isStruct(_ typeName : String) throws -> Bool {
        let findObject = find(typeName)
        
        guard let findObject else { throw FindingError.notFound}
        return findObject.type == .struct
    }
    
    public func isEnum(_ typeName : String) throws -> Bool {
        let findObject = find(typeName)
        
        guard let findObject else { throw FindingError.notFound}
        return findObject.type == .enum
    }
    
    
}
