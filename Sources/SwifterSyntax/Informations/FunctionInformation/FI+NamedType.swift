//
//  FI+NamedType.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/1/25.
//

 extension FunctionInformation : NamedType{
    
    ///Full name of the function
    ///
    ///For non-static functions, this is just the name of the function
    ///
    ///For static functions it's the fullName of the containing class + name of the function
     public var fullName : String {
        
        guard isStatic else { return name}
        let name = self.name
        
        if let parent {
            let fullNameOFParent  = parent.fullName
            return "\(fullNameOFParent).\(name)"
        }
        
        logger.error("an static function with name of \(name) doesn't have a parent. returning the name instead")
        return name
    }
}
