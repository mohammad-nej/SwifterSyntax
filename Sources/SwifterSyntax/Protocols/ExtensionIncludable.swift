//
//  ExtensionIncludable.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/31/25.
//

///Indacates object that can be included in a protocol
public protocol ExtensionIncludable{
    
    var parentExtension: ExtensionInformation? { get }
}
