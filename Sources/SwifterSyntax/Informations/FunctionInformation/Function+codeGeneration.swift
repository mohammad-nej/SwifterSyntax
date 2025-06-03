//
//  Function+codeGeneration.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/28/25.
//

extension FunctionInformation : InExtensionCodeGeneratable{
    ///Swift code to generate this function
    public var code : String {
        
        var code = ""
        let modifiers = self.modifiers.joined(separator: " ")
        
        let accessLevel = self.accessLevel.code
        
        code += modifiers + " " + accessLevel + " " + "func \(name)("
        
        let parameters = self.intputTypes.map(\.code).joined(separator: ", ")
        code += parameters + ")"
        
        if isAsync{
            code += " async"
        }
        if isThrowing{
            code += " throws"
        }
        
        if !isVoid{
            code += " -> \(self.returnType!.name){\n"
        }
        
        if let innerSourceCode{
            code += innerSourceCode + "\n" + "}"
        }else{
            code += "}"
        }
        
        return code
        
    }
    
    public var codeWithOutAccessModifier: String {
        var code = ""
        let modifiers = self.modifiers.joined(separator: " ")
        
        code += modifiers  + " " + "func \(name)("
        
        let parameters = self.intputTypes.map(\.code).joined(separator: ", ")
        code += parameters + ")"
        
        if isAsync{
            code += " async"
        }
        if isThrowing{
            code += " throws"
        }
        
        if !isVoid{
            code += " -> \(self.returnType!.name){\n"
        }
        
        if let innerSourceCode{
            code += innerSourceCode + "\n" + "}"
        }else{
            code += "}"
        }
        
        return code
    }
    
}
