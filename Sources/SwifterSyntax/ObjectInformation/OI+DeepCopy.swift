//
//  OI+DeepCopy.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/26/25.
//

extension ObjectInformation {
    
    ///Creates a fresh copy of self.
    /// - Warning: Since `deepCopy()` creates a new instance with a new `id` property it counts as a new type.
    ///
    ///  if you don't change `name` property and insert it into your `InformationHandler` since every other property is **Exactly the same**
    ///  and because `objects` in `InformationHandler` property is a `Set`, then `InformationHandler.find(_:String)`  might return type is unpredictable cause `Set` is unordered.
    public func deepCopy() -> ObjectInformation? {
        guard let info = informationHandler else { return nil}
        let copy = ObjectInformation(type: self.type, info: info)
        
        copy.fields = self.fields
        copy.url = self.url
        copy.name = self.name
        copy.availability = self.availability
        copy.conformances = self.conformances
        copy.hasNoArgumentInitializer = self.hasNoArgumentInitializer
        copy.attributes = self.attributes
        
        return copy
    }
}
