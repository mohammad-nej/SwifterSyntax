//
//  OI+isSomething.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/31/25.
//


public extension ObjectInformation {
    
    ///Indicates whether the type is an array or not?
    var isArray : Bool {
        
        return (self.name.hasSuffix("]") || self.name.hasSuffix("]?")) && //an optional array is also an array -> [Person]?
            name.hasPrefix("[")
    }
    
    ///Indicates whether the type is  optional or not?
    var isOptional : Bool {
        return name.hasSuffix("?")
    }
    
    ///Indicate whether the object is a  SwiftUI view or not?
    var isView : Bool {
        conformances.contains("View")
    }

    
    //Determines whether the object is a SwiftUI View Model or not?
    var isViewModel : Bool {
        //all view models must be class
        guard type == .class else { return false}
        
        //all should either confrom to ObservableObject or  use @Observable macro
        if conformances.contains("ObservableObject") {
            return true
        }
        
        if attributes.contains("Observable"){
            return true
        }
        return false
    }
    
}
