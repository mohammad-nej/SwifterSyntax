//
//  IH+TypeVariation.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/1/25.
//

public extension InformationHandler{
    enum TypeVariation {
        case normal //Person
        case optional //Person?
        case array //[Person]
        case arrayOfOptionals //[Person?]
        case optionalArray //[Person]?
        case optionalArrayOfOptionals  // [Person?]?
        
        init(from string : String){
            var copy  = string
            var temporalSelf = TypeVariation.normal
            
            if copy.hasSuffix("?"){
                temporalSelf = .optional
                copy.removeLast()
                if copy.hasSuffix("]"){
                    copy.removeLast()
                    temporalSelf = .optionalArray
                    if copy.hasSuffix("?"){
                        temporalSelf = .optionalArrayOfOptionals
                    }
                }
            }else if copy.hasSuffix("]"){
                temporalSelf = .array
                copy.removeLast()
                if copy.hasSuffix("?"){
                    temporalSelf = .arrayOfOptionals
                }
           }
           self = temporalSelf
        }
       }
    
   
}
