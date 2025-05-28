//
//  StructVisitor.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/20/25.
//


import SwiftSyntax
import SwiftParser
import Foundation

final class StructVisitor : SyntaxVisitor{
    init(info : InformationHandler , url : URL? = nil){
        self.info = info
        self.url = url
        super.init(viewMode: .sourceAccurate)
    }
    var objects : [ObjectInformation] = []
    let info : InformationHandler
    var url : URL?
    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        let helper = Helpers(info: info)
        let object = try? helper.getStructInfo(from: node,using: info)
        guard object != nil else { return .visitChildren}
        object!.url = url
        
        objects.append(object!)
        return .visitChildren
    }
}
