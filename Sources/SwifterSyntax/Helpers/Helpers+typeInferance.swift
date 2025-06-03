//
//  Helpers+typeInferance.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/30/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import Foundation


public extension SwiftSyntaxHelper {
    ///try to infer the type of a variable , might not succeed
    internal func inferType(from data : String ) -> ObjectInformation? {
        
        //This function is used when we have a syntax like
        // var something = somethingElse
        //where somethingElse might be global/  variable which is defined
        //somewhere else in the provided source code.
        //this supports multiple nested variabels : object.id.name. ...
        guard data.isEmpty == false else { return nil }
        let splitted = data.split(separator: ".")
        
        let firstPart = splitted.first!
        
        //Searching among the topLevelVariables to see if we can find it
        let topLevelVariable = info.topLevelVariables.first { feild in
            feild.name == String(firstPart)
        }
        guard let topLevelVariable else { return nil }
        var feildType : FeildType? = topLevelVariable
        
        //it might be multilevel nested : object.id.name
        for index in 1..<splitted.count {
            
            guard let currentField = feildType else { return nil }
            
            //now that we have found the field we have to get it's type info
            //e.g : the variable might be something like
            //var name : String , now we have to get all the info we have about
            //String to fetch it's fields
            let typeOfCurrentField = currentField.type
            guard let typeOfCurrentField else { return nil }
            let nextPart = splitted[index]
            
            
            //find the type of the variable
            feildType = typeOfCurrentField.fields.first { feild in
                feild.name == String(nextPart)
            }
        }
        return feildType!.type
    }
    
    internal func inferTypeForMultiPartVariable(from string : String , inside object : ObjectInformation?) -> ObjectInformation?{
        
        
        
        var (latesType,remaining) = inferFirstPartOfMultiPartVariable(from: string,inside: object)
        
        let parts = remaining.split(separator: ".")
        var prevType = latesType
        for part in parts{
            let nextType = prevType?.findVariable(named: part.description)?.type
            guard let nextType else { return nil}
            
            prevType = nextType
            latesType = nextType
        }
        
        return latesType
    }
    internal func inferFirstPartOfMultiPartVariable(from string : String , inside object : ObjectInformation?) -> (ObjectInformation?,String){
        guard !string.isEmpty else { return (nil,string) }
        
        //to infer a variable with multiple parts like person.name.description
        //the first part might either be a variable, or a literal
        //like 12.description so we have to test both of them
        
        //first we try to infer the type, this will succeed if the variable
        //is in form of : let name = person.name
        //assuming that person is already available in informationHandler
        var twoParts = string.split(separator: ".")
        let firstPart = twoParts.removeFirst().description
        
        var firstPartType : ObjectInformation? = nil
        if let object{
            firstPartType = object.fields.first { $0.name == firstPart}?.type
        }
        
        if let firstPartType {
            return (firstPartType,twoParts.joined(separator: "."))
        }else{
            //if we can't find the first part inside the object, we use ObjectInformation.infer
            //to see if it's a type :   Person.staticVariable. ...
            if let inffered = ObjectInformation.infer(from: firstPart,using: info){
                firstPartType = inffered
                return (firstPartType,twoParts.joined(separator: "."))
            }
            
            //we should also search inside global variables
            if let global = info.topLevelVariables.first(where: { $0.name == firstPart })?.type{
                firstPartType = global
                return (firstPartType,twoParts.joined(separator: "."))
            }
            
        }
        //if not, now we must consider forms that contain literals
        // let age = 12.description ...
        var latesType : ObjectInformation? = firstPartType
        
        
        if Int(firstPart) != nil{
            latesType = info.int
            //if we infer that it's an integer, it might also be a double
            //considering 12.5.description we can't decide between int and double
            //by just examining first part
            if let secondPart = twoParts.dropFirst().first?.description{
                if Int(secondPart) != nil{
                    latesType = info.double
                    twoParts.removeFirst()
                }
            }
        }
        else if UUID(uuidString: firstPart.description) != nil{
            latesType = info.uuid
        }else if Bool(firstPart.description) != nil{
            latesType = info.bool
        }
        
        
        return (latesType,twoParts.joined(separator: "."))
    }
}
