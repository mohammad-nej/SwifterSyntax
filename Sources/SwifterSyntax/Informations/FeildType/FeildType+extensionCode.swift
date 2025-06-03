//
//  FeildType+extensionCode.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/29/25.
//

extension FeildType : InExtensionCodeGeneratable {
    public var codeWithOutAccessModifier: String {
        guard !isEnvironmentVariable else {
            return "Environemt variable can't be inside extension"
        }
        
        guard let type else{
            return "type of \(name) is unkonwn"
        }
        
        var code = ""
        if attributes.isEmpty == false{
            code += attributes.joined(separator: " ") + " "
        }
        if modifiers.isEmpty == false{
            code += modifiers.joined(separator: " ") + " "
        }
        
      
        code += mutationType.code
        code += " \(name) : \(type.name)"
        
        if let initialValue = self.initialValue{
            let valueCode =  " = " + initialValue.code
            code += valueCode
        }else if let innerSourceCode {
            let sourceCode = " {\n\(innerSourceCode.indented)\n}\n"
            code += sourceCode
        }
        return code
    }
}
