//
//  Helpers+struct+class.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/30/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder


public extension SwiftSyntaxHelper {
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
        object.conformances.upsert(protcols)
        object.attributes.upsert(attibutes)
        
        //Getting info of all struct variables
        for member in syntax.memberBlock.members{
            //Getting variables inside struct
            if  let variableDecl = member.decl.as(VariableDeclSyntax.self){
                
                if let info = try getVariableInfo(from: variableDecl,inside: object){
                    object.append(info)
                }
            }
            //Getting functions inside struct
            if let funcDecl = member.decl.as(FunctionDeclSyntax.self){
                let funcInfo = getFunctionInfo(from: funcDecl)
                funcInfo.parent = object
                object.functions.upsert(funcInfo)
            }
        }
        
    
        return object
    }
    
    
    func getClassInfo(from syntax : ClassDeclSyntax, using info : InformationHandler) throws -> ObjectInformation
    {
        let name = syntax.name.text
        let object = ObjectInformation.fromString(name,type: .class , using: info )
        
        
        //Getting info of all class variables
        syntax.memberBlock.members.forEach { member in
            if let variableDecl = member.decl.as(VariableDeclSyntax.self){
                
                let info = try? getVariableInfo(from: variableDecl,inside: object)
             
                if let info{
                    object.append(info)
                }else{
                    assertionFailure("unable to get variable info")
                }
                
            }
            //Getting functions inside struct
            if let funcDecl = member.decl.as(FunctionDeclSyntax.self){
                let funcInfo = getFunctionInfo(from: funcDecl)
                funcInfo.parent = object
                object.functions.upsert(funcInfo)
            }
        }
        
        //Getting attributes like @Model , @Observable
        let attibutes = getAttribute(from: syntax)
        
        //Getting inheritance like View
        let inheritanceClause = getInheritance(from: syntax)
        
        #warning("ham inja , ham tuye tarif struct bayad hatman innerType haro ham begiram, yani dakhele ye struct mishe ye struct tarif kard o ...")
 
        object.name =  syntax.name.text
        object.attributes.upsert(attibutes)
        object.conformances.upsert(inheritanceClause)
        return object
    }
}
