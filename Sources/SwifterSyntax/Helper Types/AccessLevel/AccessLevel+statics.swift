//
//  AccessLevel+statics.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/29/25.
//

public extension AccessLevel{
    
    static var unknown : AccessLevel {
        .init(.unknown)
    }
    
    static var `internal` : AccessLevel {
        .init(.internal)
    }
    
    static var `public` : AccessLevel {
        .init(.public)
    }
    
    static var `private` : AccessLevel {
        .init(.private)
    }
    
    static var `fileprivate` : AccessLevel {
        .init(.fileprivate)
    }
    
    static var `open` : AccessLevel {
        .init(.open)
    }
}
