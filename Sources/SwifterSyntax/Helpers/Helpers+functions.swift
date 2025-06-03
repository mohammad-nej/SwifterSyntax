//
//  Helpers+functions.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/30/25.
//
import SwiftSyntax
import SwiftSyntaxBuilder

public extension SwiftSyntaxHelper {
    func getFunctionInfo(from syntax : FunctionDeclSyntax) -> FunctionInformation{
        
        //name of the function
        let name = syntax.name.text
        
        //modifiers of function : static , private , ...
        var modifiers = syntax.modifiers.map { decl in
            decl.name.text
        }
        
        //public,private ,...
        let accessLevel = AccessLevel(from: modifiers)
        
        //removing accessLevel from the list of modifiers
        modifiers = modifiers.filter{ $0 != accessLevel.rawValue}
        
        //function parameters
        let paramets = getFunctionInputs(from: syntax.signature.parameterClause.parameters)
        
        //function body(codes inside)
        let body = syntax.body?.formatted().description
        
        //return type
        var returnType : ObjectInformation? = nil
        if let returnTypeName = syntax.signature.returnClause?.type.as(IdentifierTypeSyntax.self)?.name.text{
            returnType = .fromString(returnTypeName, using: info)
        }
        
        //creating functionInfo object
        let functionInfo = FunctionInformation(name: name, intputTypes: paramets, returnType: returnType)
        functionInfo.accessLevel = accessLevel
        functionInfo.modifiers.upsert(modifiers)
        functionInfo.innerSourceCode = body
        
        return functionInfo
    }
    
    
    func getInnerCode(from syntax : CodeBlockSyntax?) -> String?{
        //inner source code
        return syntax?.statements.map{$0.formatted().description}.joined(separator: "\n")
       
    }
    func getFunctionInputs(from syntax : FunctionParameterListSyntax) -> [FunctionInformation.FunctionInput] {

        return syntax.compactMap{ parameter in
            let firstName = parameter.firstName.text
            let secondName = parameter.secondName?.text
            let typeName = parameter.type.as(IdentifierTypeSyntax.self)?.name.text
            
            guard let typeName else {
                assertionFailure("must not be nil")
                logger.error("typeName is nil when reading parameter \(firstName), please check the code")
                
                return Optional<FunctionInformation.FunctionInput>.none}
            let type = ObjectInformation.fromString(typeName, using: info)
            
            return FunctionInformation.FunctionInput(name: firstName, secondName: secondName, type: type)
        }
    }
    
//    internal func setParentOfFunctionInformation(_ syntax : FunctionDeclSyntax, function : FunctionInformation){
//        let parentNode = syntax.parent
//        if let parentNode = parentNode?.parent?.parent?.as(SourceFileSyntax.self) {
//            //this is a global function, thus we just return
//            return
//        }else if let parentNode = parentNode?.parent?.parent?.parent?.as(ClassDeclSyntax.self) {
//            let type : ObjectInformation = .fromString(parentNode.name.text, using: self.info)
//            
//            function.parent = type
//        }else if let parentNode = parentNode?.parent?.parent?.parent?.as(StructDeclSyntax.self){
//            let type : ObjectInformation = .fromString(parentNode.name.text, using: self.info)
//            
//            function.parent = type
//        }else if let parentNode = parentNode?.parent?.parent?.parent?.as(EnumDeclSyntax.self){
//            let type : ObjectInformation = .fromString(parentNode.name.text, using: self.info)
//            
//            function.parent = type
//        }else if let parentNode = parentNode?.parent?.parent?.parent?.as(ProtocolDeclSyntax.self){
//            let type : ObjectInformation = .fromString(parentNode.name.text, using: self.info)
//            
//            function.parent = type
//        }else if let parentNode = parentNode?.parent?.parent?.parent?.as(ExtensionDeclSyntax.self){
//            let lineNumber = parentNode.position.utf8Offset
//            let fileURL = parentNode.id
//            
//            function.parent = type
//        }
//    }
}
