//
//  SP+CodeInfo.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/3/25.
//

import SwiftSyntax
import Foundation
import SwiftParser

    
///Used internally to store information about a ".swift" file
struct CodeInfo : Hashable, Equatable{
    
    ///URL which this code is extracted from
    ///
    ///Might be nil if code is given directly as String
    let file : URL?
    
    ///Source code we want to parse in String
    let sourceCode : String
    
    ///Parsed source code
    ///
    ///You can use this to furthure parse the code using SwiftSyntax library
    let syntax : SourceFileSyntax
    
    ///Hash value of the source code , used internally for creating `UniqueID`
    let sourceCodeHashValue : Int
    
    init(file: URL?, sourceCode: String, syntax: SourceFileSyntax) {
        self.file = file
        self.sourceCode = sourceCode
        self.syntax = syntax
        self.sourceCodeHashValue = sourceCode.hashValue
    }
    
    init?(file url : URL){
        
        //Skipping non swift files
        guard url.pathExtension == "swift" else {
            logger.error("\(url.absoluteString) is not a Swift file, skipping...")
            return nil
        }
        
        //Reading file
        let code = try? String(contentsOf: url, encoding: .utf8)
        guard let code else { return nil}
        
        //parsing
        let syntax = Parser.parse(source: code)
        
        //Creating object
        self.file = url
        self.sourceCode = code
        self.syntax = syntax
        self.sourceCodeHashValue = code.hashValue
        
    }
    
    init(from code : String){
        
        let syntax = Parser.parse(source: code)
        let hash = code.hashValue
        
        self.file = nil
        self.sourceCodeHashValue = hash
        self.syntax = syntax
        self.sourceCode = code
        
    }
    
    init(syntax : SourceFileSyntax){
        let code = syntax.description
        let hash = code.hashValue
        
        self.file = nil
        self.sourceCodeHashValue = hash
        self.syntax = syntax
        self.sourceCode = code
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sourceCodeHashValue)
    }
    public static func == (lhs: CodeInfo, rhs: CodeInfo) -> Bool {
        return lhs.sourceCodeHashValue == rhs.sourceCodeHashValue
    }
}


extension CodeInfo {
    
    static func codes(from files : [URL]) -> [CodeInfo] {
        files.compactMap{ CodeInfo.init(file: $0) }
    }
    
    static func codes(from codes : [String]) -> [CodeInfo] {
        codes.map{ CodeInfo(from: $0) }
    }
    
}

