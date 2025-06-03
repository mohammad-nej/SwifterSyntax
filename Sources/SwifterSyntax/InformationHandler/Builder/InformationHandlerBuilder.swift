//
//  InformationHandlerBuilder.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/1/25.
//


//Builder here
///Builder for InformationHandler which injects some Hard-Coded data into InformationHandler such as String, Int , ...
struct InfromationHandlerBuilder{
    
    
    private let infoHandler = InformationHandler()

    
    fileprivate  var stringInformation : ObjectInformation  {
        
        var info = ObjectInformation(type: .struct, info: infoHandler)
        
        info.name = "String"
        info.availability = .public
        info.conformances = ["Codable" , "Sendable" , "Comparable","Hashable" , "Equatable",
                             "CustomStringConvertible", "CustomDebugStringConvertible",
        ]

        return info
    }
    fileprivate  var intInformation : ObjectInformation {
        
        var info = ObjectInformation(type: .struct, info: infoHandler)
        
        info.name = "Int"
        info.availability = .public
        info.conformances = ["Codable" , "Sendable" , "Comparable" , "Equatable",
                             "CustomStringConvertible", "Hashable"
        ]
 
        return info
    }
    
    fileprivate  var doubleInformation : ObjectInformation  {
        
        var info = ObjectInformation(type: .struct, info: infoHandler)
        
        
        info.name = "Double"
        info.availability = .public
        info.conformances = ["Codable" , "Sendable" , "Comparable" , "Equatable",
                             "CustomStringConvertible", "Hashable"
        ]
        return info
    }
    
    fileprivate  var cgfloatInformation : ObjectInformation  {
        
        var info = ObjectInformation(type: .struct, info: infoHandler)
        
        
        info.name = "CGFloat"
        info.availability = .public
        info.conformances = ["Codable" , "Sendable" , "Comparable" , "Equatable",
                             "CustomStringConvertible", "Hashable"
        ]
        return info
    }
    fileprivate  var boolInformation : ObjectInformation {
        
        var info = ObjectInformation(type: .struct, info: infoHandler)
        
        info.name = "Bool"
        info.availability = .public
        info.conformances = ["Codable" , "Sendable" , "Equatable",
                             "CustomStringConvertible", "Hashable"
        ]

        return info
    }
    fileprivate   var dateInformation : ObjectInformation  {
        
        var info = ObjectInformation(type: .struct, info: infoHandler)
       
        
        
        info.name = "Date"
        info.availability = .public
        info.conformances = ["Codable" , "Sendable" , "Equatable", "Comparable",
                             "CustomStringConvertible", "Hashable",
                             "Equatable"
                             
        ]

        return info
    }
    fileprivate  var uuidInformation : ObjectInformation  {
        
        var info = ObjectInformation(type: .struct, info: infoHandler)
        var isOk : Bool = false
        
        info.name = "UUID"
        info.availability = .public
        info.conformances = ["Codable" , "Sendable" , "Equatable",
                             "CustomStringConvertible", "Hashable"
        ]
        return info
    }
    
    
    

    func build() -> InformationHandler{
        let types =  [
            stringInformation,
            dateInformation ,
            uuidInformation,
            doubleInformation,
            boolInformation,
            intInformation,
            cgfloatInformation
        ]
        types.forEach { obj in
            infoHandler.append(obj)
        }
        
        addDefaultVariables(info: infoHandler)
        return infoHandler
    }
    
    func addDefaultVariables(info : InformationHandler){
        for index in info.objects.indices {
            
            //adding .description to all types
            info.objects[index].append(.computedProperty(name: "description", type: info.string ))
            
            
            if info.objects[index].name == "UUID"{
                let uuidString = ComputedPropertyBuilder(name: "uuidString", type: info.string)
                    .accessLevel(.public)
                    .build()
                info.objects[index].append(uuidString)
            }
            
            if info.objects[index].name == "CGFloat"{
                let pi =
                ComputedPropertyBuilder(name: "pi", type: info.cgfloat)
                    .accessLevel(.public)
                    .isStatic(true)
                    .build()
                let zero = ComputedPropertyBuilder(name: "pi", type: info.cgfloat)
                    .accessLevel(.public)
                    .isStatic(true)
                    .build()

                let staticVariables : [FeildType] = [pi,zero]
                
//                info.objects[index].staticVariables.append(contentsOf: staticVariables)
            }
            
            if info.objects[index].name == "Double"{
                let pi =
                ComputedPropertyBuilder(name: "pi", type: info.double)
                    .accessLevel(.public)
                    .isStatic(true)
                    .build()
                let zero = ComputedPropertyBuilder(name: "pi", type: info.double)
                    .accessLevel(.public)
                    .isStatic(true)
                    .build()

                let infinity = ComputedPropertyBuilder(name: "infinity", type: info.double)
                    .accessLevel(.public)
                    .isStatic(true)
                    .build()
                let staticVariables : [FeildType] = [pi,zero,infinity]
                
                info.objects[index].append( staticVariables)
            }
            
            if info.objects[index].name == "Int"{
                let min =
                ComputedPropertyBuilder(name: "min", type: info.int)
                    .accessLevel(.public)
                    .isStatic(true)
                    .build()
                let max = ComputedPropertyBuilder(name: "max", type: info.int)
                    .accessLevel(.public)
                    .isStatic(true)
                    .build()

                let zero = ComputedPropertyBuilder(name: "zero", type: info.int)
                    .accessLevel(.public)
                    .isStatic(true)
                    .build()
                let staticVariables : [FeildType] = [min,zero,max]
                
                info.objects[index].append( staticVariables)
            }
            
            if info.objects[index].name == "String"{
       
                let isEmpty = ComputedPropertyBuilder(name: "isEmpty", type: info.bool)
                    .accessLevel(.public)
                    .build()
                let capitalized = ComputedPropertyBuilder(name: "capitalized", type: info.string)
                    .accessLevel(.public)
                    .build()
                let count = ComputedPropertyBuilder(name: "count", type: info.int)
                    .accessLevel(.public)
                    .build()
                
                let feilds : [FeildType] = [isEmpty,capitalized,count]
                info.objects[index].append( feilds)
            }
            
            
        }
        
        
        
    }
}
