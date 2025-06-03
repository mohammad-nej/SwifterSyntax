//
//  AccessLevel+equatable+hashable.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/29/25.
//

extension AccessLevel {
    
    public static func == (lhs: AccessLevel,rhs:AccessLevel) -> Bool {
        lhs.type == rhs.type &&
        lhs.parentAccessLevel == rhs.parentAccessLevel
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(parentAccessLevel)
    }
}
