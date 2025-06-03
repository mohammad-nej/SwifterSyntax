//
//  Helpers.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/13/25.
//
import SwiftSyntax
import SwiftSyntaxBuilder
import CoreGraphics
import Foundation


public enum ParseError: Error{
    case gettingVariableNameFailed , noInitialValue , noMutationModifier,propertyIsComputed, incorrectSourceCode, unSupportedCode
}
///Type used for extracting info using SwiftSyntax library. this type is mostly used internally to gather information about your code
///
///Ideally, you shouldn't be using this type, unless you want to work with `SwiftSyntax` directly.
public struct SwiftSyntaxHelper{
    
    let info : InformationHandler
    public init(info: InformationHandler) {
        self.info = info
    }
}

