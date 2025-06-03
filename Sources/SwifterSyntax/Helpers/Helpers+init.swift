//
//  Helpers+function+init.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/30/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder


public extension SwiftSyntaxHelper{
    func getInitializers(from syntax : InitializerDeclSyntax, for type : ObjectInformation) -> InitializerType{
        let initializer = InitializerType(for: type)
        
        //Getting modifiers
        var modifiers = syntax.modifiers.map({$0.name.text})
        
        //getting accessLevel
        let accessLevel = AccessLevel(from: modifiers)
        initializer.accessLevel = accessLevel
        
        //filtering accessLevel out
        modifiers = modifiers.filter({$0 != accessLevel.rawValue})
        initializer.modifiers = modifiers
        
        var isNullable = false
        if let questionMakr = syntax.optionalMark?.text{
            if questionMakr == "?"{
                isNullable = true
            }
        }
        
        initializer.isNullable = isNullable
        
        initializer.inputs = getFunctionInputs(from: syntax.signature.parameterClause.parameters)
        
        //Async/throws
        if let functionEffects = syntax.signature.effectSpecifiers{
            if functionEffects.asyncSpecifier != nil{
                initializer.isAsync = true
            }
            if functionEffects.throwsClause != nil{
                initializer.isThrowing = true
            }
        }
        
        //inner source code
        let innerCode = getInnerCode(from: syntax.body)
        initializer.innerSourceCode = innerCode
        
        
        return initializer
    }
 
}
