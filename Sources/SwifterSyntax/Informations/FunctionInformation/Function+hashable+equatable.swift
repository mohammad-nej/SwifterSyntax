//
//  Function+hashable+equatable.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/28/25.
//

public extension FunctionInformation{
    public static func == (lhs: FunctionInformation, rhs: FunctionInformation) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
