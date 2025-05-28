//
//  TreeExtrator.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/13/25.
//
import SwiftSyntax
import SwiftParser
import Foundation







public struct SyntaxParser {
    
    public init(infoHandler: InformationHandler){
        self.infoHandler = infoHandler
    }
    public let infoHandler : InformationHandler
    
    public func rerun(source : SourceFileSyntax){
        let classVisitor = ClassVisitor(info: infoHandler)
        classVisitor.walk(source)
    

        let structVisitor = StructVisitor(info: infoHandler)
        structVisitor.walk(source)
   

        let topLevelVariables = TopLevelVariablesVisitor(info: infoHandler)
         topLevelVariables.walk(source)
        infoHandler.topLevelVariables = topLevelVariables.variables
        
        
        
     

        
    }
    public func parse(source : String , url : URL?){
        
        let sourceFile = Parser.parse(source: source)
        let classVisitor = ClassVisitor(info: infoHandler)
        let structVisitor = StructVisitor(info: infoHandler)
        let topLevelVariables = TopLevelVariablesVisitor(info: infoHandler)
        
        if let url{
            classVisitor.url = url
            structVisitor.url = url
        }
        classVisitor.walk(sourceFile)
        infoHandler.append(contentsOf: classVisitor.objects)
        
        structVisitor.walk(sourceFile)
        infoHandler.append(contentsOf: structVisitor.objects)
        
        topLevelVariables.walk(sourceFile)
        infoHandler.topLevelVariables = topLevelVariables.variables
        
        
        
        for index in classVisitor.objects.indices{
            classVisitor.objects[index].sourceFile = sourceFile
        }
        
        for index in structVisitor.objects.indices{
            structVisitor.objects[index].sourceFile = sourceFile
        }
        
        rerun(source: sourceFile)
    }
    
    func parseGeneratedViewModelFor(view : ObjectInformation , source : SourceFileSyntax , url: URL) -> ObjectInformation{
        
        
//        let sourceFile = Parser.parse(source: source)
        
//        let sourceFormatted = sourceFile.formatted().description
        let classVisitor = ClassVisitor(info: infoHandler)
        
        classVisitor.url = url
        
        classVisitor.walk(source)
        
        
        
        for index in classVisitor.objects.indices{
            classVisitor.objects[index].sourceFile = source
        }
        
        
        infoHandler.append(contentsOf: classVisitor.objects)
        
        let viewModel = classVisitor.objects.first!

        
        return viewModel
    }
    
    
}
