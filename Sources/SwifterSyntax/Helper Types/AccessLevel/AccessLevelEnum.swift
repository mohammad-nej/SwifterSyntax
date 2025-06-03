//
//  AccessLevelEnum.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/29/25.
//

extension AccessLevel{
    ///Access Level of a variable/type : public , private , ...
    public enum AccessLevelEnum : String,Sendable, CaseIterable , Identifiable, CodeGeneratable {
        public var id : Self { self}
        public var code : String {
            guard self != .unknown else{
                return ""
            }
            return rawValue
        }
        case `public`, `internal`, `fileprivate`, `private`,`open` , unknown
        

    }
    
    public var rawValue : String {
        type.rawValue
    }
}
