//
//  FunctionInformation+usefullData.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/28/25.
//

public extension FunctionInformation {
    
    ///Determines if function has a return value or not?
    var isVoid : Bool {
        return returnType == nil
    }
    
    var isGlobal : Bool {
        return parent == nil
    }
    
    var isMutating : Bool {
        return modifiers.contains("mutating")
    }
    
    var isStatic : Bool {
        return modifiers.contains("static")
    }
    
    
}
