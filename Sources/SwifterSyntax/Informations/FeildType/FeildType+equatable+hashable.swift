//
//  FeildType+equatable+hashable.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/29/25.
//

public extension FeildType{
    static func == (lhs: FeildType , rhs: FeildType) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
