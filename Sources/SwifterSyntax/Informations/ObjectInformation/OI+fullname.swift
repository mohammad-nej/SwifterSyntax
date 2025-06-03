//
//  OI+fullname.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/1/25.
//


public extension ObjectInformation{
    
    ///Display the full name of the object including it's parent(s) name
    ///
    ///For Example :
    ///```swift
    ///struct Person{
    /// struct Info{
    ///     //...
    /// }
    /// //...
    ///}
    ///```
    ///in this case fullName of Info is `Person.Info`
    ///
    ///fullName of Person is `Person`
    var fullName : String {
        
        var pured = self.name.replacing( "[", with: "")
        pured = pured.replacing("]", with: "")
        pured = pured.replacing("?", with: "")
        var superClasses : [String] = [pured]
        
        var supper : ObjectInformation? = self.parentType
        while(supper != nil){
            superClasses.append(supper!.name)
            supper = supper!.parentType
        }
        
        return superClasses.reversed().joined(separator: ".")
    }
    
}
