//
//  Initializer+equatable+hashbale.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/29/25.
//

public extension InitializerType{
    
    static func == (lhs : InitializerType , rhs: InitializerType) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
