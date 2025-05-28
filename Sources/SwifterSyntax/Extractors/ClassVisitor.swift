//
//  ClassVisitor.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/20/25.
//


import SwiftSyntax
import SwiftParser
import Foundation

class ClassVisitor : SyntaxVisitor{
    init(info : InformationHandler){
        self.info = info
        super.init(viewMode: .sourceAccurate)
    }
    var objects : [ObjectInformation] = []
    var url : URL?
    let info : InformationHandler
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let helper = Helpers(info: info)
        let object = try? helper.getObjectInfo(from: node,using: info)
        guard object != nil else { return .visitChildren}
        object!.url = url
        objects.append(object!)
        return .visitChildren
    }
}
