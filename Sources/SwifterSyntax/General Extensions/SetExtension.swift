//
//  SetExtension.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/1/25.
//
import OrderedCollections
extension OrderedSet {
    
    ///Insert or Update and element in a set
    ///
    ///This method will update the current element if it's already exists in the set
    mutating func upsert(_ newElement: Element?) {
        if let element = newElement {
            self.updateOrAppend(element)
        }
    }
    
    mutating func upsert( _ elements : [Element]){
        elements.forEach{ self.updateOrAppend($0)}
    }
}

extension OrderedSet where Element : NamedType {
    
    ///Finds an element with it's name
    func find(named name : String) -> Element? {
        self.first(where: { $0.name == name || $0.fullName == name })
    }
}



public extension Collection where Element : Comparable {
    
    func ascending() -> [Element] {
        return self.sorted(by: <)
    }
    
    func descending() -> [Element] {
        return self.sorted { first, second in
            first > second
        }
    }
}
