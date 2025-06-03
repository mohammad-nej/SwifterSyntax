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
        
        code += "// MARK: - Initializers\n"
        
        for initializer in self.initializers where initializer.parentExtension == nil {
            code += initializer.code + "\n"
        }
        code += "\n"
        
        code += "// MARK: - Properties\n"
        
        //if a variable is inside an extension , we don't want to define it inside the main type
        for variable in fields where variable.parentExtension == nil {
            
            code += variable.code + "\n"
        }
        
        code += "\n"
      
        
        code += "// MARK: - Functions\n"
        
        for function in self.functions where function.parentExtension == nil {
            code += function.code + "\n"
        }
        
        code += "}"
        return code
    }
}
