//
//  ClassVisitor.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/20/25.
//


import SwiftSyntax
import SwiftParser
import Foundation

///Extract information of classes found in the code base
final class ClassVisitor :  SyntaxVisitor, MyVisitor{
    var cleanUp: (() -> Void)? = nil
    
    
    
    init(info : InformationHandler){
        self.info = info
        
        super.init(viewMode: .sourceAccurate)
    }
    
    var codeInfo : CodeInfo?
    
    var results: [ObjectInformation] = []
   
    let info : InformationHandler
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        
        guard let codeInfo else {
            logger.error("CodeInfo is not set, please use run(with:) method instead of walk to set the CodeInfo")
            return .skipChildren}
        
        let helper = SwiftSyntaxHelper(info: info)
        let object = try? helper.getObjectInfo(from: node,using: info)
        guard object != nil else { return .visitChildren}
        object!.url = codeInfo.file
        object!.id = .init(hash: codeInfo.sourceCodeHashValue, at: node.position.utf8Offset)
        results.append(object!)
        
        
        
        info.append(object!)
        return .visitChildren
    }
    
    
}
