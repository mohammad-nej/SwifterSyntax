//
//  TopLevelVariablesVisitor.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/20/25.
//


import SwiftSyntax
import SwiftParser
import Foundation

///Extract information of global variables found in the code base
class VariablesVisitor : SyntaxVisitor,MyVisitor{
    
    var cleanUp: (() -> Void)? = nil
    
    
    
    public enum Mode{
        case all , global
    }
    
    var codeInfo: CodeInfo?
    
    var results : [FeildType] = []
    let info : InformationHandler
    
    ///Indicated whether we should only visit global variables or not?
    let mode : Mode
    
    init(info: InformationHandler,mode : Mode){
        self.info = info
        
        self.mode = mode
        super.init(viewMode: .sourceAccurate)
     
        
    }
    override func visit(_ node : VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        //listing all global  variables
        let helper = SwiftSyntaxHelper(info: info)
        
        guard let codeInfo else {
            logger.error("CodeInfo is not set, please use run(with:) method instead of walk to set the CodeInfo")
            return .skipChildren}
        
        var variable : FeildType? = nil
        if mode == .all{
            variable = try? helper.getVariableInfo(from: node , inside: nil)
            guard let variable else { return .skipChildren}
            
            
            
            results.append(variable)
            

            
        }else{
            
            //global variabels
            //in this case the variable is a top level variable
            if ((node.parent?.parent?.parent?.as(SourceFileSyntax.self)) != nil){
                variable = try? helper.getVariableInfo(from: node , inside: nil)
                guard let variable else { return .skipChildren}
                
                results.append(variable)
                

            }
        }
        
        if let variable{
            variable.id = .init(hash: codeInfo.sourceCodeHashValue, at: node.position.utf8Offset)
            
            //if we are unable to infer the type of a variable, in this case helper.getVariableInfo has already set
            //needRerun to true, but we have insert the source code into the codeToRerun variable for rerun later on
            if variable.type == nil {
                info.codesToRerun.insert(codeInfo)
            }
            
            if variable.isGlobal{
                info.append(variable)
            }
            
        }
        
        
        
        return .visitChildren
    }
}
