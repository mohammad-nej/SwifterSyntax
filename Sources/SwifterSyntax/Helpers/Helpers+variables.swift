//
//  Helpers+variables.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/30/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder


public extension SwiftSyntaxHelper{
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
        let accessLevel = AccessLevel(from: modifiers)
        
        //removing accessLevel from modifies list cause it's redundant
        modifiers = modifiers.filter { $0 != accessLevel.rawValue }
        
        guard let mutationType else { throw ParseError.noMutationModifier}
        
        
        let bindingPattern = syntax.bindings.first
        guard let bindingPattern else { throw ParseError.gettingVariableNameFailed}
        
        //Getting variable type
        let type = try getVariableType(from: syntax, inside: object)
        
        //Get inner source code (if property is computed)
        let code = getInnerCode(of: syntax)
        
        if let code{
            let feild = FeildType(name: variableName,
                             type: type,
                             attributes: attributes,
                             mutationType: mutationType,
                             initialValue: nil,
                             isComputedProperty: true,
                             modifiers: modifiers,
                             accessLevel: accessLevel
            )
            feild.innerSourceCode = code
            
            return feild
        }
        
        //Getting initial Value of the variable
        var initialValueExpression =  getInitialValue(of: bindingPattern)
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
        
    }
}

public extension SwiftSyntaxHelper {
    
    func getVariableName(from syntax : VariableDeclSyntax ) throws -> String{
        let text = syntax.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
        guard let text  else {
            throw ParseError.gettingVariableNameFailed
        }
        return text
    }
    
    ///Gets the code inside a computed property, non computed properties will return nil
    func getInnerCode(of syntax : VariableDeclSyntax) -> String?{
        if let code = syntax.bindings.first?.accessorBlock?.accessors.as(CodeBlockItemListSyntax.self){
            return code.formatted().description
        }
        return nil
    }
    func getInitialValue(of binding : PatternBindingListSyntax.Element)  -> InputLitteral? {
        
        //Check if variable is a computed proprty or not?
        if (binding.accessorBlock?.accessors.as(CodeBlockItemListSyntax.self)) != nil {
            return nil
        }
        
        let value = binding.initializer?.value
        guard let value else { return nil }
        
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
        
        //if the variables is an array type are without type annotation : var names = ["Korush","Sina","Mina"]
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
        info.needRerun = true
        return nil
    }

    func getModifiers(from syntax :  VariableDeclSyntax) -> [String] {
        syntax.modifiers.compactMap { modifier in
            modifier.name.text
        }
    }
    
}
