//
//  FeildType+fullName.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/1/25.
//

 extension FeildType : NamedType {
    
    ///Full name of this variable
    ///
    ///For non-static variables , it's just the name of the variable
    ///
    ///For static variables, it's the fullName of the parent object + name of the variable
    public var fullName: String {
        guard isStatic else { return name}
        let name = self.name
        
        if let parent = self.type{
            let fullNameOfParent = parent.fullName
            return "\(fullNameOfParent).\(name)"
        }
        
        logger.error("an static function with name of \(name) doesn't have a parent. returning the name instead")
        return name
    }
}
