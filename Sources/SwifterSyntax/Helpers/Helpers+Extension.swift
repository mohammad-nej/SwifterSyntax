//
//  Helpers+Extension.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/30/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder



public extension SwiftSyntaxHelper {
    
    ///Gets general info about extension like accessLevel, modifiers , type of which it's extending , conformaces
    ///
    /// - Warning: This function doesn't get information of types/variables defined inside the extension
    func getExtensionGeneralInfo(from node : ExtensionDeclSyntax) -> ExtensionInformation{
        
        var modifiers  = node.modifiers.map(\.name.text)
        
        //public private ....
        let accessLevel = AccessLevel(from: modifiers)
        
        //other modifiers ( i don't think of anything else , but anyway xD)
        modifiers = modifiers.filter{$0 != accessLevel.rawValue}
        
        //the type which is being extended
        let typeName = node.extendedType.description
        let type = ObjectInformation.fromString(typeName, using: info)
        
        //protocol confromances
        let conformances = node.inheritanceClause?.inheritedTypes.map(\.description) ?? []
        
        //creating object
        let extensionType = ExtensionInformation(of: type)
        extensionType.accessLevel = accessLevel
        extensionType.modifiers.upsert(modifiers)
        conformances.forEach { extensionType.append($0) }
        
        return extensionType
    }
}
