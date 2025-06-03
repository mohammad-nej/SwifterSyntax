//
//  SP+swiftUI.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/3/25.
//

import SwiftUI
import SwiftSyntax


extension SyntaxParser{
    
    ///used to parsed a code generated to be a SwiftUI ViewModel
    public func parseGeneratedViewModelFor(view : ObjectInformation , source : SourceFileSyntax , url: URL) -> ObjectInformation{
    
        let classVisitor = ClassVisitor(info: infoHandler)
        
        let codeInfo = CodeInfo(file:url,sourceCode: source.description,syntax: source)
        classVisitor.codeInfo = codeInfo
        
        classVisitor.walk(source)
        
        classVisitor.results.forEach { $0.sourceFile = source}
        
        let viewModel = classVisitor.results.first!
        
        view.viewModel = viewModel
        
        return viewModel
    }
}
