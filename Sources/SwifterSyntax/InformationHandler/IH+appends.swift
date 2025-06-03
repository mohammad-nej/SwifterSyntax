//
//  IH+appends.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/1/25.
//

extension InformationHandler{
    
    
    public func append(_ `extension` : ExtensionInformation){
        self.extensions.upsert(`extension`)
    }
    public func append(_ objectInformation : ObjectInformation) {
        self.objects.upsert(objectInformation)
    }
    public func append(contentsOf types : [ObjectInformation] ){
        types.forEach { obje in
            self.objects.upsert(obje)
        }
    }
    
    ///Add a variable to global variables
    public func append(_ variable : FeildType){
        //Just in case!
        guard variable.isGlobal else {
            logger.warning("Function \(variable.fullName) is not a global function, insertion will be ignored")
            return
        }
        self.topLevelVariables.upsert(variable)
    }
    
    ///Add a function to global functions
    public func append(_ function : FunctionInformation){
        //Just in case!
        guard function.isGlobal else {
            logger.warning("Function \(function.fullName) is not a global function, insertion will be ignored")
            return
        }
        self.topLevelFunctions.upsert(function)
    }
}
