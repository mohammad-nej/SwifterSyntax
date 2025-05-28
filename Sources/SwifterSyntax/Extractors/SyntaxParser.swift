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
    
    
    //Because when we are inferring types, we parse source code in order
    //the order of files might affect our inference. for example:
    //file1 :
    //var personName = myPerson.name
    //file2:
    //struct Person{
    //  var name : String
    //}
    //var myPerson = Person(name : "Mohammad")
    //
    //if we parse file2 first, then by the time we reach file1 we already know `myPerson`s type thus
    //we can infer `personName` type, but if we parse file1 first, then file2, we can't infer the type of
    //`personName` variable cause `myPerson` is not visited yet.
    //to go around this problem, on the first run, if we can't infer the type of a variable it will be nil
    // then we parse the entire code a second time (using the same InformationHandler, thus keeping our previous knowledge).
    // this trick will make the order of files irrelevant.
    private func rerun(source : SourceFileSyntax){
        
        guard infoHandler.needRerun else { return}
        
        let classVisitor = ClassVisitor(info: infoHandler)
        classVisitor.walk(source)
    

        let structVisitor = StructVisitor(info: infoHandler)
        structVisitor.walk(source)
   

        let topLevelVariables = TopLevelVariablesVisitor(info: infoHandler)
         topLevelVariables.walk(source)
        infoHandler.topLevelVariables = topLevelVariables.variables
        
        
        
     
        infoHandler.needRerun = false
        
    }
    
    
    /// Parse swift code
    /// - Parameter url: Address of a .swift file
    /// - Returns: All the information extracted from the code
    public func parse(url : URL) -> InformationHandler?{
        let extention = url.pathExtension
        guard extention == ".swift" else { return nil }
        let source = try? String(contentsOf: url, encoding: .utf8)
        
        guard let source else {return nil}
        
        return parse(source: source, url: url)
        
    }
    
    /// Parse swift code from string
    /// - Parameter source: Swift code
    /// - Returns: All the information extracted from the code
    public func parse(source : String) -> InformationHandler?{
       return parse(source: source, url: nil)
    }
    
    public func parse(source : String , url : URL?) -> InformationHandler{
        
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
        return infoHandler
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
