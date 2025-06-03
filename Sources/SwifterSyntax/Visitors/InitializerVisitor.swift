//
//  InitializerVisitor.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/31/25.
//

import SwiftSyntax
import Foundation




final class InitializerVisitor : SyntaxVisitor,MyVisitor {
    
    
    var cleanUp: (() -> Void)?
    
    let info : InformationHandler
    
    var sourceHash : Int = 0
    
    public init(for type : ObjectInformation, info: InformationHandler) {
        self.info = info
        
        self.baseType = type
        super.init(viewMode: .sourceAccurate)
    }
    
    var codeInfo : CodeInfo?
    
    ///the type which this initializer belongs to
    let baseType : ObjectInformation
    var results : [InitializerType] = []
    
    
    override func visit(_ node : InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        let helper = SwiftSyntaxHelper(info: info)
        
        guard let codeInfo else {
            logger.error("CodeInfo is not set, please use run(with:) method instead of walk to set the CodeInfo")
            return .skipChildren}
        
        let initializeType = helper.getInitializers(from: node, for: baseType)
        initializeType.id = .init(hash: codeInfo.sourceCodeHashValue, at: node.position.utf8Offset)
        results.append(initializeType)
        
        if let type = initializeType.type{
            type.initializers.upsert(initializeType)
        }
        
        
        return .skipChildren
    }
}
