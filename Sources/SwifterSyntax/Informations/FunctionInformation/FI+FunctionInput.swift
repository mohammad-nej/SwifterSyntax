//
//  FI+FunctionInput.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/31/25.
//

extension FunctionInformation{
    
    ///Holds data of a functions input parameter
    ///
    ///```swift
    ///func append(contentsOf files : URL){
    /////...
    ///}
    ///```
    ///name -> contentsOf
    ///secondName : files
    ///type : url
    public struct FunctionInput : CodeGeneratable{
        let name : String
        let secondName : String?
        let type : ObjectInformation
        
        public init(name: String, secondName: String? = nil, type: ObjectInformation) {
            self.name = name
            self.secondName = secondName
            self.type = type
        }
        
        public var code : String {
            var code = "\(name)"
            if let secondName = secondName {
                code += " \(secondName)"
            }
            code += " : \(type.name)"
            return code
        }
    }
}
