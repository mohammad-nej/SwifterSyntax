//
//  UniqueID+comparable.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/2/25.
//

extension UniqueID: Comparable {
    public static func < (lhs: UniqueID, rhs: UniqueID) -> Bool {
        return lhs.id < rhs.id
    }
}
