//
//  InitializerVisitor.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/31/25.
//

import SwiftSyntax
import SwiftParser
import Foundation


final class ExtensionVisitor : SyntaxVisitor, MyVisitor{
    var cleanUp: (() -> Void)? = nil
    
    
    
    
    public init(info: InformationHandler) {
        self.info = info
       
        super.init(viewMode: .sourceAccurate)
    }
    
    let info : InformationHandler
    
    var codeInfo: CodeInfo?
    
    ///List of all extensions found in the source code
    var results : [ExtensionInformation] = []
    
    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        let helper = SwiftSyntaxHelper(info: info)
        
        guard let codeInfo else {
            logger.error("CodeInfo is not set, please use run(with:) method instead of walk to set the CodeInfo")
            return .skipChildren}
        
        let extensionInfo : ExtensionInformation = helper.getExtensionGeneralInfo(from: node)
        
        let currentType = extensionInfo.type

        let structVisitor = StructVisitor(info: info)
        let classVisitor = ClassVisitor(info: info)
        let functionVisitor = FunctionVisitor(info: info)
        let computedVariable : VariablesVisitor = VariablesVisitor(info: info, mode: .all)
        
        let visitors : [any MyVisitor] = [
            structVisitor,
            classVisitor,
            functionVisitor,
            computedVariable
        ]
        
        
        let parser = SyntaxParser(infoHandler: info)
        parser.codes.insert(codeInfo)
        parser.enableRerun = false
        parser.visitors = visitors
      
        
        parser.parse()
        
        
        
        //appending the founded info to the extension
        structVisitor.results.forEach { extensionInfo.append($0) }
        classVisitor.results.forEach { extensionInfo.append($0) }
        functionVisitor.results.forEach { extensionInfo.append($0) }
        computedVariable.results.forEach { extensionInfo.append($0)}
        
        //adding this extension to the type
        extensionInfo.type.extensions.upsert(extensionInfo)
        
        results.append(extensionInfo)
        
        info.append(extensionInfo)
        return .visitChildren
    }
}
