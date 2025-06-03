//
//  MyVisitor.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/2/25.
//

import SwiftSyntax
import Foundation

protocol MyVisitor : SyntaxVisitor{
    associatedtype Result : UniqueIDable
    var results : [Result] { get }
    

    ///Information gather about the code
    var codeInfo : CodeInfo? { get set }
    
    
    var info : InformationHandler { get }
    
    ///Extra work that a Visitor might need to do after it's done
    var cleanUp : (() -> Void)? { get set }
        
}

extension MyVisitor {
    func run(with codeInfo : CodeInfo){
        self.codeInfo = codeInfo
        
        self.walk(codeInfo.syntax)
        if let cleanUp{
            cleanUp()
        }
    }
    
}

