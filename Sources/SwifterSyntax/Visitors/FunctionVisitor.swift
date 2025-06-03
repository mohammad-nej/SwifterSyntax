//
//  FunctionVisitor.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/31/25.
//

import SwiftSyntax
import Foundation



final class FunctionVisitor: SyntaxVisitor , MyVisitor {
    var cleanUp: (() -> Void)?

    let info : InformationHandler
    var results : [FunctionInformation] = []
    var codeInfo: CodeInfo? = nil
    
    var autoAppend : Bool = false
    
    public init(info: InformationHandler) {
        self.info = info
       
        super.init(viewMode: .sourceAccurate)
        self.cleanUp = { [weak self] in
            guard let self else { return }
            
            self.results.forEach {  function in
                if function.isGlobal{
                    info.append(function)
                }
            }
            
        }
    }
    public override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let helper = SwiftSyntaxHelper(info: info)
       
        guard let codeInfo else {
            logger.error("CodeInfo is not set, please use run(with:) method instead of walk to set the CodeInfo")
            return .skipChildren}
        
        let functionInfo = helper.getFunctionInfo(from: node)
        functionInfo.id = .init(hash: codeInfo.sourceCodeHashValue, at: node.position.utf8Offset)
        results.append(functionInfo)
        
        if functionInfo.isGlobal{
            info.append(functionInfo)
        }
        return .skipChildren
    }
    
}
