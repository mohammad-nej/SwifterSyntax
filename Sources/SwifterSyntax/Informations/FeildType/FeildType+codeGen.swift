//
//  FeildType+codeGen.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/29/25.
//

extension FeildType{
    public var code : String {
        guard let type else {
            return "Error: Type of variable \(name) is unknown"
        }
        
        if isEnvironmentVariable{
            return "@Environment(\(type.name).self) \(accessLevel.code) var \(name)"
        }
        
        var code = ""
        if attributes.isEmpty == false{
            code += attributes.joined(separator: " ") + " "
        }
        if modifiers.isEmpty == false{
            code += modifiers.joined(separator: " ") + " "
        }
        
        let accessLevelCode =  accessLevel.code
        if accessLevelCode.isEmpty == false{
            code += accessLevelCode + " "
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
