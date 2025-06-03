//
//  extension+equatable+hashable.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/28/25.
//

public extension ExtensionInformation{
    
    static func == (lhs: ExtensionInformation, rhs: ExtensionInformation) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
