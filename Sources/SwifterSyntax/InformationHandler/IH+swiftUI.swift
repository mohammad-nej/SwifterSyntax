//
//  IH+swiftUI.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/1/25.
//

public extension InformationHandler{
    var viewsWithOutViewModel : [ObjectInformation]{
        objects.filter { object in
            guard object.isView else { return false}
            return hasViewModel(object) == false
        }
    }
    
//    Indicates whether a View already has a View Model or not?
    func hasViewModel(_ object : ObjectInformation) -> Bool {
       
        //we only care about view models inside views
        guard object.isView else { return false }
    
            //We should loop through all fields in a view to see if there is
            //any view model in it or not ?
            for field in object.fields {
                let object = field.type
                guard let object else { continue}
                if object.isViewModel{
                    return true
                }
                
            }
            return false
        }
    
}
