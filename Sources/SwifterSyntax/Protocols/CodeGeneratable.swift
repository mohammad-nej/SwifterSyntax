//
//  CodeGeneratable.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/21/25.
//

///used for generating swift code
public protocol CodeGeneratable {
    var code : String { get }
    
}

///used for generating swift code inside extension
public protocol InExtensionCodeGeneratable {
    var codeWithOutAccessModifier : String { get }
}

