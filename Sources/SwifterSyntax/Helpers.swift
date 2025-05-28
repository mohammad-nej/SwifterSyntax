//
//  Helpers.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/13/25.
//
import SwiftSyntax
import SwiftSyntaxBuilder
import CoreGraphics
import Foundation


public enum ParseError: Error{
    case gettingVariableNameFailed , noInitialValue , noMutationModifier,propertyIsComputed, incorrectSourceCode, unSupportedCode
}
public struct Helpers{
    
    let info : InformationHandler
    public init(info: InformationHandler) {
        self.info = info
    }
}
public extension Helpers{
     func getVariableName(from syntax : VariableDeclSyntax ) throws -> String{
        let text = syntax.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
        guard let text  else {
            throw ParseError.gettingVariableNameFailed
        }
        return text
    }
     func getVariableNames(from syntax : ClassDeclSyntax) throws -> [String]{
        return try syntax.memberBlock.members.compactMap { memeber in
            let variableDecl = memeber.decl.as(VariableDeclSyntax.self)
            guard let variableDecl else { return Optional<String>.none }
            return try getVariableName(from: variableDecl)
        }
    }
    
     func getInitialValue(of binding : PatternBindingListSyntax.Element) throws -> InputLitteral? {
        //Check if variable is a computed proprty or not?
        if binding.accessorBlock != nil{
             throw ParseError.propertyIsComputed
        }
        
        let value = binding.initializer?.value
        guard let value else { throw ParseError.noInitialValue}
        
        if let converted = value.as(StringLiteralExprSyntax.self)?.segments.first?.description {
            return  .init(exact:"\"\(converted.description)\"")
        }else if let converted = value.as(IntegerLiteralExprSyntax.self)?.literal.text{
            return converted.description.litteral
        }else if let converted = value.as(FloatLiteralExprSyntax.self)?.literal.text{
            return converted.description.litteral
        }else if let converted = value.as(BooleanLiteralExprSyntax.self)?.literal.text{
            return converted.description.litteral
        }//for cases like : var id = UUID() this will return "UUID()"
         else if let converted = value.as(FunctionCallExprSyntax.self){
            return converted.description.litteral
        }
      
        return nil
        
    }
      func getAttribute(from syntax : ClassDeclSyntax) -> [String]{
        return syntax.attributes.compactMap { attrib in
            let attribeName = attrib.as(AttributeSyntax.self)?
                .attributeName
                .as(IdentifierTypeSyntax.self)?
                .name.text
            guard let attribeName else { return nil }
            return "@\(attribeName)"
        }
    }
      func getAttribute(from syntax : some DeclGroupSyntax) -> [String]{
        return syntax.attributes.compactMap { attrib in
            let attribeName = attrib.as(AttributeSyntax.self)?
                .attributeName
                .as(IdentifierTypeSyntax.self)?
                .name.text
            guard let attribeName else { return nil }
            return "@\(attribeName)"
        }
    }
      func getAttribute(from syntax : VariableDeclSyntax) -> [String] {
        return syntax.attributes.compactMap { attrib in
            
            let attribName = attrib.as(AttributeSyntax.self)?
                .attributeName
                .as(IdentifierTypeSyntax.self)?
                .name.text
            guard let attribName else { return nil }
            return "@\(attribName)"
        }
    }
      func getInheritance(from syntax : ClassDeclSyntax) -> [String] {
        return syntax.inheritanceClause?.inheritedTypes.compactMap{ types in
            types.type.as(IdentifierTypeSyntax.self)?.name.text
        } ?? []
    }
      func getProtocols(from syntax : StructDeclSyntax) -> [String] {
        return syntax.inheritanceClause?.inheritedTypes.compactMap{ types in
            types.type.as(IdentifierTypeSyntax.self)?.name.text
        } ?? []

    }
    ///try to infer the type of a variable , might not succeed
    private func inferType(from data : String ) -> ObjectInformation? {
        
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
    func getVariableType(from syntax : VariableDeclSyntax, inside object : ObjectInformation?) throws -> ObjectInformation? {
        
        let binding = syntax.bindings.first
        guard let binding else { throw ParseError.incorrectSourceCode}
        
        
        
       
        
        let type = binding.typeAnnotation?.type//
        
        //This code will work if the type is written in declaration : var age : Int = 12
        if let text = type?.as(IdentifierTypeSyntax.self)?.name.text{
            return .fromString(text,using:info)
            
        }
        //array types like :   var names : [String] ..
        else if let text = type?.as(ArrayTypeSyntax.self)?.element.as(IdentifierTypeSyntax.self)?.name.text{
            
            return .fromString("[\(text)]",using: info)
            
        }
        //for optionals
        else if let text = type?.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self)?.name.text{
            return  .fromString("\(text)?",using: info)
        }
        
       
        
        
        //variables with some/any type
        if let someType = binding.typeAnnotation?.type.as(SomeOrAnyTypeSyntax.self){
            var type = ""
            type = someType.someOrAnySpecifier.text
            let existentialType = someType.constraint.as(IdentifierTypeSyntax.self)?.name.text
            guard let existentialType else { throw ParseError.gettingVariableNameFailed }
            
            return .fromString(type + " " + existentialType,using: info)
            
        }
        
        //if not we have to try to infer the type using it's initializer
        // e.g. var id = UUID()
        var initilizerClause = binding.initializer?.value
        
        //if the variables is an array typeare without type annotation : var names = ["Korush","Sina","Mina"]
        //we use the first element of arrays type to infer the type
        //NOTE: this package doesn't support heterogeneous arrays.
        var isArray = false
        if let isArrayExpr = initilizerClause?.as(ArrayExprSyntax.self){
            initilizerClause = isArrayExpr.elements.first?.expression
            isArray = true
        }
        
        if let initilizerClause{
            if  (initilizerClause.as(StringLiteralExprSyntax.self) != nil){
                return isArray ? info.string.array : info.string
            }else if  (initilizerClause.as(IntegerLiteralExprSyntax.self) != nil){
                return isArray ? info.int.array : info.int
            }else if (initilizerClause.as(FloatLiteralExprSyntax.self) != nil){
                return isArray ? info.double.array :info.double
            }else if (initilizerClause.as(BooleanLiteralExprSyntax.self) != nil){
                return isArray ? info.bool.array : info.bool
            }else if let expr = initilizerClause.as(FunctionCallExprSyntax.self){ //var id = UUID()
                let typeName =  expr.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName.text ?? "UNKOWN"
                return isArray ? .fromString("[\(typeName)]",using: info) : .fromString(typeName,using: info)
            }
            else if let expr = initilizerClause.as(MemberAccessExprSyntax.self){
                //this happens in enums : var mode : SelectionMode = .single
                let formatted = expr.formatted().description.replacingOccurrences(of: " ", with: "")
                let infer = inferTypeForMultiPartVariable(from: formatted, inside : object)
                if let infer{
                    return infer
                }
                
            }
        }
        
        //variables in Environment : eg. @Environment(Coordinator.self) private var cord
        for attrib in syntax.attributes{
            guard let type = attrib.as(AttributeSyntax.self)?
                .arguments?
                .as(LabeledExprListSyntax.self)?
                .first?
                .expression
                .as(MemberAccessExprSyntax.self)?
                .base?
                .as(DeclReferenceExprSyntax.self)?
                .baseName
                .text
            else{ continue}
            return .fromString(type,using: info)
        }
        
       return nil
    }
    private func inferTypeForMultiPartVariable(from string : String , inside object : ObjectInformation?) -> ObjectInformation?{
        
        
        
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
    private func inferFirstPartOfMultiPartVariable(from string : String , inside object : ObjectInformation?) -> (ObjectInformation?,String){
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
      func getModifiers(from syntax : VariableDeclSyntax) -> [String] {
        syntax.modifiers.compactMap { modifier in
            modifier.name.text
        }
    }
    func getVariableInfo(from syntax : VariableDeclSyntax , inside object : ObjectInformation?) throws -> FeildType?{
//
        //getting variable name
        let variableName = try getVariableName(from: syntax)
        
        //getting attributes like @State and ....
        let attributes = getAttribute(from: syntax )
        
        //Getting mutation modifier (var/let)
        var mutationType : MutationType?
        
        let mutationText = syntax.bindingSpecifier.text
        if mutationText == "var" {
            mutationType = .var
            
        }else if mutationText == "let"{
            mutationType = .let
            
        }
        
        //like  , private
        var modifiers = getModifiers(from: syntax)
       
        
        //Getting access level like private,internal,public, ...
        let accessLevelRawValueIndex = modifiers.firstIndex{ value in
            AccessLevel.allCases.contains(where: { $0.rawValue == value })
        }
        let accessLevel = accessLevelRawValueIndex != nil ?  AccessLevel(rawValue: modifiers[accessLevelRawValueIndex!])! : .internal
        
        //removing accessLevel from modifies list cause it's redundant
        if let accessLevelRawValueIndex{
          
            modifiers.remove(at: accessLevelRawValueIndex)
        }
        guard let mutationType else { throw ParseError.noMutationModifier}
        
        
        let bindingPattern = syntax.bindings.first
        guard let bindingPattern else { throw ParseError.gettingVariableNameFailed}
        
        //Getting variable type
        let type = try getVariableType(from: syntax, inside: object)
        do{
            
            //Getting initial Value of the variable
            var initialValueExpression = try getInitialValue(of: bindingPattern)
            if initialValueExpression == nil {
                //optional types even if they don't have any initialValue
                //they will automatically receive nil
                // var age : Int?
                // age -> nil
                if let type , type.isOptional{
                    initialValueExpression = .nil
                }
            }
            
            //Returning the result
            return FeildType(name: variableName,
                             type: type,
                             attributes: attributes,
                             mutationType: mutationType,
                             initialValue: initialValueExpression,
                             isComputedProperty: false,
                             modifiers: modifiers,
                             accessLevel: accessLevel
                             
            )
        }catch{
            //if the property is a computed property we just skip it cause we don't
            //have to enter computed proprties into the view Model

            if let error = error as? ParseError, error == .propertyIsComputed || error == .noInitialValue {
                return FeildType(name: variableName,
                                 type: type,
                                 attributes: attributes,
                                 mutationType: mutationType,
                                 initialValue: nil,
                                 isComputedProperty: error == .propertyIsComputed,
                                 modifiers: modifiers,
                                 accessLevel: accessLevel
                )
            }
            return nil
        }
       
    }
    
    func getObjectInfo(from syntanx : some DeclSyntaxProtocol, using info : InformationHandler) throws -> ObjectInformation?{
        if let classSyntax = syntanx as? ClassDeclSyntax{
            return try getClassInfo(from: classSyntax, using: info)
        }else if let structSyntax = syntanx as? StructDeclSyntax{
            return try getStructInfo(from: structSyntax, using: info)
        }else{
            print("declaration is ignored cuase it's unsupported")
            return nil
        }
        
        
    }
    
    func getStructInfo(from syntax : StructDeclSyntax , using info : InformationHandler) throws -> ObjectInformation{
          let name = syntax.name.text
        let object = ObjectInformation.fromString(name,type: .struct , using: info )
          
          //Getting attributes like @Model , @Observable
          let attibutes = getAttribute(from: syntax)
          
          //Getting inheritance like View
          let protcols = getProtocols(from: syntax)
          object.name =  syntax.name.text
          object.conformances = protcols
          object.attributes = attibutes
          
          //Getting info of all struct variables
          for member in syntax.memberBlock.members{
              let variableDecl = member.decl.as(VariableDeclSyntax.self)
              guard let variableDecl else { throw ParseError.gettingVariableNameFailed }
              if let info = try getVariableInfo(from: variableDecl,inside: object){
                  object.fields.append(info)
              }
          }
          return object
    }
    
    
      func getClassInfo(from syntax : ClassDeclSyntax, using info : InformationHandler) throws -> ObjectInformation
    {
        let name = syntax.name.text
        let object = ObjectInformation.fromString(name,type: .class , using: info )

        
        //Getting info of all class variables
        let feildsInfo =  try syntax.memberBlock.members.compactMap { member in
            let variableDecl = member.decl.as(VariableDeclSyntax.self)
            guard let variableDecl else { return Optional<FeildType>.none }
            return try getVariableInfo(from: variableDecl,inside: object)
           
        }
        
        //Getting attributes like @Model , @Observable
        let attibutes = getAttribute(from: syntax)
        
        //Getting inheritance like View
        let inheritanceClause = getInheritance(from: syntax)
        
        //Creating class info object
        
        object.fields = feildsInfo
        object.name =  syntax.name.text
        object.attributes = attibutes
        object.conformances = inheritanceClause
        return object
    }
}
