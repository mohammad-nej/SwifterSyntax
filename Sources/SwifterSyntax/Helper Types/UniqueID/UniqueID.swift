//
//  UniqueID.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/2/25.
//

import SwiftSyntax
import Foundation


///A unique identifier for objects found in the source code
///
///For object that you create directly the ID is just a `uuidString`
///
///For objects parsed by the parser it's the combination of the
///
/// sourceCode.hashValue + position of the node
///
///which makes this node unique and recognizable during multiple runs of parsing cause neither hashValue nor position
///will change anyway
public struct UniqueID: Hashable , Equatable , Sendable, Identifiable {
    
   
    
    public let id : String
    
    internal init(in string : String , at position : Int){
        
        self.id = string.hashValue.description + "_\(position)"
    }
    
    internal init(hash value : Int , at position : Int){
        self.id = value.description + "_\(position)"
    }
    
    internal init(){
        self.id = UUID().uuidString
    }
    public static func == (lhs: UniqueID, rhs: UniqueID) -> Bool {
        return rhs.id == lhs.id
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
