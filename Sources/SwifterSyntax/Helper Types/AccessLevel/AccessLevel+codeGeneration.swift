//
//  AccessLevel+codeGeneration.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/29/25.
//


public extension AccessLevel {
    
    var code : String {
        //if this variable/method/object is inside an extension
        if let parentExtension = parentAccessLevel {
            
            //if we are in an extension , and accessLevel is unknown
            //which means that it's not explicitly written, we don't have to
            //write it either
            if self.type == .unknown {
                return ""
            }
            
            if self.type != parentExtension{
                return self.type.rawValue
            }
             //if they are equal, it's not needed
            //e.g: in a private extension we don't need to write private in front of
            //every single function
            return ""
        }
        
        //if we are not in an extension and accessLevel is internal or unknown
        // we just dont write it
        if self.type == .unknown || self.type == .internal {
            return ""
        }
        
        //if we are not in an extension, and accessLevel is anything but .internal/.unknown
        return self.type.rawValue
        
    }
    var codeWithOutAccessModifier: String{
        code
    }
    
}
