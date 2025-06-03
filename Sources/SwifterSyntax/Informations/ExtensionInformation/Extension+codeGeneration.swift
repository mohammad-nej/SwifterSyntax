//
//  Extension+codeGeneration.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/28/25.
//

public extension ExtensionInformation {
    var code : String {
        var code = "//Auto-generated extension:\n"
        code = "\(accessLevel.code) extension \(type.name)"
        
        //adding conformances
        if conformances.isEmpty == false {
            code += " : "
            code += conformances.joined(separator: ", ")
        }
        code += " {\n"
        
        //nested types:
        if self.innerTypes.isEmpty == false{
            code += "//Nested Types:\n".indented
            innerTypes.forEach { code += $0.code.indented }
        }
        
        
        //initializers
        if self.initializers.isEmpty == false{
            code += "//Initializers:\n".indented
            
            initializers.forEach{ initalizer in
                
                code += initalizer.code.indented
            }
        }
        
        
        //Variabels
        if self.fields.isEmpty == false{
            code += "//Variables:\n".indented
            
            for variable in self.fields{
                if variable.accessLevel == self.accessLevel || variable.accessLevel == .unknown{
                    code += variable.codeWithOutAccessModifier.indented + "\n"
                }else{
                    code += variable.code.indented + "\n"
                }
            }
        }
        
        //functions
        if self.functions.isEmpty == false{
            code += "//Functions:\n"
            
            for function in self.functions{
                if function.accessLevel == self.accessLevel || function.accessLevel == .unknown{
                    code += function.codeWithOutAccessModifier.indented + "\n"
                }else{
                    code += function.code + "\n"
                }
            }
        }
        
        
        code += "}\n"
        return code
    }
}

public extension String{
    ///indent all lines of a string by one tab (\t)
    var indented : String {
        let lines = self.split(separator: "\n")
        return lines.map({ "\t\($0)" }).joined(separator: "\n")
    }
}
