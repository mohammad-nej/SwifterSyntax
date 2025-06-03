//
//  TreeExtrator.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/13/25.
//
import SwiftSyntax
import SwiftParser
import Foundation







public class SyntaxParser {
    
    
    var parseModel : ParsingMode = .fromString
    
    var visitors : [any MyVisitor] = [
        
        
    ]
    
    public init(infoHandler: InformationHandler){
        self.infoHandler = infoHandler
    }
    
    ///Holds the information for codes that needs to be parsed
    var codes : Set<CodeInfo> = []
    
    ///Can be use to control if we should do a rerun or not?
    ///
    ///
    ///This is used internally inside ExtensionVisitor to void unnecessary rerun
    var enableRerun : Bool = true
    
    public let infoHandler : InformationHandler
    
  
    

    ///Parses codes
    @discardableResult
    internal func parse() -> InformationHandler {
       
        if self.visitors.isEmpty{
            let visitors : [any MyVisitor] = [
                ClassVisitor(info: infoHandler),
                StructVisitor(info: infoHandler),
                VariablesVisitor(info: infoHandler, mode: .all),
                FunctionVisitor(info: infoHandler),
                ExtensionVisitor(info: infoHandler),
            ]
            self.visitors = visitors
        }
        
        for code in codes{
            for visitor in visitors {
                visitor.run(with:code)
            }
        }
        
        reRun()
        
        return infoHandler
    }

    
    
 
    
//    @discardableResult
//    func parseExtension(sourceSyntax : SourceFileSyntax , for type : ObjectInformation, url : URL?) -> InformationHandler{
//       
//        let extensionVisitor = ExtensionVisitor(info: infoHandler)
//        
//        parseModel = .fromString
//        if let url{
//            extensionVisitor.url = url
//        }
//        
//        extensionVisitor.walk(sourceSyntax)
//        
//        
//        reRun()
//        return infoHandler
//    }
    
//    @discardableResult
//    public func parseExtension(source : String, for type : ObjectInformation,url:URL?) -> InformationHandler {
//        let sourceFile = Parser.parse(source: source)
//        return parseExtension(sourceSyntax: sourceFile, for: type, url: url)
//       
//    }
//   
    
//   
//    @discardableResult
//     func _parse(sourceSyntax : SourceFileSyntax , url : URL?) -> InformationHandler{
//        
//        let codeInfo = CodeInfo(file: url, sourceCode: sourceSyntax.formatted().description, syntax: sourceSyntax)
//         
//        let classVisitor = ClassVisitor(info: infoHandler,url: url)
//        let structVisitor = StructVisitor(info: infoHandler,url: url)
//        let topLevelVariables = VariablesVisitor(info: infoHandler,mode:.global)
//        
//        let visitors : [any MyVisitor] = [classVisitor,structVisitor,topLevelVariables]
//        
//        
//        
//        visitors.forEach {
//            //Setting url
//            $0.url = url
//            
//            //Setting hash value
//            if let currentSourceCodeHash{
//                $0.sourceHash = currentSourceCodeHash
//            }
//            
//            //Starting the visotor
//            $0.walk(sourceSyntax)
//        }
//   
//        infoHandler.topLevelVariables.upsert(topLevelVariables.results)
//   
//        //adding extra info
//        classVisitor.results.forEach { $0.sourceFile = sourceSyntax}
//        structVisitor.results.forEach { $0.sourceFile = sourceSyntax}
//        
//        reRun {
//            visitors.forEach { $0.walk(sourceSyntax) }
//            infoHandler.topLevelVariables.upsert(topLevelVariables.results)
//        }
//        
//        return infoHandler
//    }
  
    
 
    
    
}
