//
//  TopLevelVariablesVisitor.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/20/25.
//


import SwiftSyntax
import SwiftParser
import Foundation

class TopLevelVariablesVisitor : SyntaxVisitor{
    var variables : [FeildType] = []
    let info : InformationHandler
    
    init(info: InformationHandler){
        self.info = info
        super.init(viewMode: .sourceAccurate)
    }
    override func visit(_ node : VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        //listing all global and static variables
        let helper = Helpers(info: info)
        
        //global variabels
        //in this case the variable is a top level variable
        if ((node.parent?.parent?.parent?.as(SourceFileSyntax.self)) != nil){
            let info = try? helper.getVariableInfo(from: node , inside: nil)
            guard let info else { return .skipChildren}
            
            variables.append(info)
            return .visitChildren
        }
        
        //static variables
        let info = try? helper.getVariableInfo(from: node, inside: nil)
        guard let info else { return .skipChildren}
        
        if info.isStatic{
            variables.append(info)
        }
        return .visitChildren
    }
}
