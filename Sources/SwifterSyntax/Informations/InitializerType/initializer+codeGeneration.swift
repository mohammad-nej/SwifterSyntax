//
//  initializer+codeGeneration.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/29/25.
//

extension InitializerType  {
    
    public var code : String {
        
        
        var code = ""
        
        let accessLevelCode = accessLevel.code
        code += accessLevelCode.isEmpty ? "" : accessLevelCode + " "
        let modifiersCode = modifiers.joined(separator: " ")
        code += modifiersCode.isEmpty ? "" : modifiersCode + " "
        code += isNullable ? "init?(" : "init("
        code += inputs.map(\.code).joined(separator: ", ")
        code += ")"
        
        if isAsync{
            code += " async"
        }
        
        if isThrowing{
            code += " throws"
        }
        
        code += "{"
        
        if let innerSourceCode , !innerSourceCode.isEmpty{
            code += "\n"
            code += innerSourceCode.indented
            code += "\n"
        }
        code += "}\n"
        
        return code
    }
    
}
