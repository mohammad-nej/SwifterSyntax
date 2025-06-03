//
//  SP+publicParses.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/3/25.
//

import SwiftSyntax
import Foundation

extension SyntaxParser{
    
    
    ///Parse multiple Swift files at once.
    @discardableResult
    public  func parse(files : [URL] ) -> InformationHandler {
        var sources : [CodeInfo] = CodeInfo.codes(from: files)
    
        parse()
        
        return infoHandler
    }
    
    /// Parse swift code
    /// - Parameter url: Address of a .swift file
    /// - Returns: All the information extracted from the code
    @discardableResult
    public  func parse(url : URL) -> InformationHandler?{
        
        let codeInfo = CodeInfo(file: url)
        
        guard let codeInfo else {
            logger.error("Unable to parse from file")
            return nil
        }
        
        codes.insert(codeInfo)
        
        return parse()
        
    }
    
    /// Parse swift code from string
    /// - Parameter source: Swift code
    /// - Returns: All the information extracted from the code
    @discardableResult
    public  func parse(source : String) -> InformationHandler{

        let codeInfo = CodeInfo(from: source)
        self.codes.insert(codeInfo)
        return parse()
    }
    
    /// Parse multiple swift codes at once
    /// - Parameter sources: Swift source code
    /// - Returns: Object containing all the parsed information
   @discardableResult
    public func parse(sources: [String]) -> InformationHandler{
        let codes = CodeInfo.codes(from: sources)
        codes.forEach { self.codes.insert($0)}
        return parse()
    }
    
   
    
    @discardableResult
    public func parse(syntax : SourceFileSyntax) -> InformationHandler{
        let code = CodeInfo(syntax: syntax)
        codes.insert(code)
        return parse()
    }
//    ///Extract information from a swift file using it's `SourceFileSyntax`
//    ///
//    ///Use this only if you have already parsed your data using `SwiftSyntax` library , otherwise just use `parse(source:String,url:URL?)` instead.
//    ///
//    public  func parse(sourceSyntax : SourceFileSyntax , url : URL?) -> InformationHandler{
//        parseModel = .fromSyntax
//        return _parse(sourceSyntax: sourceSyntax, url: url)
//        
//    }
    
//    @discardableResult
//    internal  func parse() -> InformationHandler{
//        
//        let sourceFile = Parser.parse(source: source)
//        currentSourceCodeHash = source.hashValue
//        parseModel = .fromString
//        return _parse(sourceSyntax: sourceFile, url: url)
//    }
}
