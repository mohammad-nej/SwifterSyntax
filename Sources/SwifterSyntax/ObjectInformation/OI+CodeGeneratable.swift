//
//  OI+.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/26/25.
//


import Foundation
import SwiftSyntax

extension ObjectInformation : CodeGeneratable {
    public var code : String {
        var code = "\(attributes.joined(separator: "")) \(availability.code) \(type.code) \(name)"
        if conformances.isEmpty == false {
            code += " : \(conformances.joined(separator: ", "))"
            code.removeLast(2)
        }
        code += " {\n"
        
        for variable in fields {
            code += variable.code + "\n"
        }
        
        code += "}"
        return code
    }
}