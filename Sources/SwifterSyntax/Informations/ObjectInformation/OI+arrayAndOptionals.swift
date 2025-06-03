//
//  OI+arrayAndOptionals.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/31/25.
//

extension ObjectInformation {
    
    ///Person -> [Person?]
    public var  arrayOfOptionals : ObjectInformation? {
        
        guard let info = informationHandler else { return nil}
        
        ///if current type is optional we just don't want to add another ? in front of the type name
        let name = self.isOptional ? self.name.removeLast().description : self.name
        
        if let arrayOfOptionals = info.find("[" + name + "?]" ){
            return arrayOfOptionals
        }
        return self.optional?.array
        
    }
    
    ///Person -> [Person]?
    public var optionalArray : ObjectInformation? {
        guard let info = informationHandler else { return nil}
        
        
        let name = self.name
        
        if let optionalArray = info.find("[" + name + "]?" ){
            return optionalArray
        }
        
        return  self.array?.optional
    }
    
    ///Person -> [Person?]?
    public var optionalArrayOfOptionals : ObjectInformation? {
        
        guard let info = informationHandler else { return nil}
        
        ///if current type is optional we just don't want to add another ? in front of the type name
        let name = self.isOptional ? self.name.removeLast().description : self.name
        
        if let optionalArrayOfOptionals = info.find("[" + name + "?]?" ){
            return optionalArrayOfOptionals
        }
        return self.optional?.array?.optional
    }
    
    ///Person -> [Person]
    public var array : ObjectInformation? {
        guard let info = informationHandler else { return nil}
        
        //if we have already created an array type for this type, we just return it
        if let array =  info.find("[" + self.name + "]" ){
            return array
        }
        
        //deep copying
        let copy = ObjectInformation(type: .struct,info: info) //arrays are Struct in swift
        
        //inserting array type into the InformationHandler for later use
        info.append(copy)
        copy.name = "[" +  self.name + "]"
        let fields : [FeildType] = [
            .computedProperty(name: "first", type: self.optional! ),
            .computedProperty(name: "last", type: self.optional!),
        ]
        copy.append(fields)
        copy.url = nil
        copy.attributes = []
        copy.conformances = []
        copy.viewModel = nil
        return copy
    }
    
    ///Person -> Person?
    public  var optional : ObjectInformation?  {
        guard let info = informationHandler else { return nil}
        
        ///if this type is already an optional , we just return itself
        guard !self.isOptional else { return self}
        
        //if we have already created an optional type for this type , we just return it
        if let optional =  info.find(self.name + "?"){
            return optional
        }
        
        let copy = self.deepCopy()
        guard let copy else { return nil}
        
        //inserting optional type into the InformationHandler for later use
        info.append(copy)
        
        copy.name += "?"
        return copy
    }
    
    
    
}
