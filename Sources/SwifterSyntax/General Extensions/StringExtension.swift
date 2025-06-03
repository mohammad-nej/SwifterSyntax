//
//  StringExtension.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/2/25.
//

extension String : @retroactive Identifiable {
    public var id : Self { self}
}
