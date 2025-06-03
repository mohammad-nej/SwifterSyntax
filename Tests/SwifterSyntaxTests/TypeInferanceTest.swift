//
//  TypeInferanceTest.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/1/25.
//

import Testing
import SwiftSyntax
import SwiftParser
@testable import SwifterSyntax


///Tests reletad to type inferance
final class TypeInferenceTest{
   
    let info : InformationHandler
    var parser : SyntaxParser
    
    init(){
        let info = InformationHandler.new
        self.info = info
        self.parser = SyntaxParser(infoHandler: info)
    }
    
    @Test func simpeTypeInferanceTest() throws{
        
        //Int
        var code =
        """
            let age = 12
        """
        var ageType = try #require(parseAndGetVariable(code: code, variable: "age"))
        #expect(ageType.type == info.int)
        
        //Double
        code =
        """
            let age1 = 12.5
        """
        ageType = try #require(parseAndGetVariable(code: code, variable: "age1"))
        #expect(ageType.type == info.double)
        
        //String
        code =
        """
            let age2 = "hello"
        """
        ageType = try #require(parseAndGetVariable(code: code, variable: "age2"))
        #expect(ageType.type == info.string)
        
        //Bool
        code =
        """
            let age3 = true
        """
        ageType = try #require(parseAndGetVariable(code: code, variable: "age3"))
        #expect(ageType.type == info.bool)
        
        //UUID
        code =
        """
            let age4 = UUID()
        """
        ageType = try #require(parseAndGetVariable(code: code, variable: "age4"))
        #expect(ageType.type == info.uuid)
        
        //Person
        code =
        """
            let age5 = Person(name : "Mohammad")
        """
        ageType = try #require(parseAndGetVariable(code: code, variable: "age5"))
        #expect(ageType.type?.name == "Person")
        
        //CGFloat
        code =
        """
            let age6 : CGFloat = 25.7
        """
        ageType = try #require(parseAndGetVariable(code: code, variable: "age6"))
        #expect(ageType.type == info.cgfloat)
        
    }
    
    private func parseAndGetVariable(code : String , variable name : String) -> FeildType?{
        parser.parse(source: code)
        return info.topLevelVariables.find(named: name)
    }
    
    @Test func multiLevelTypeInferanceTest2() throws{
        
        let code =
        """
            let ageName = person.age.text
        """
        
        //creating person type
        let person : ObjectInformation = .fromString("Person", using: info)
        let feilds : [FeildType] = [
            .var(name: "age", type: info.int),
            .var(name: "name", type: info.string)
        ]
        person.append(feilds)
        
        //addding .text to info.int
        let textFeild : FeildType = .var(name: "text", type: info.string)
        info.int.append(textFeild)
        
        //creating person global variable
        let personVariable : FeildType = .var(name: "person", type: person)
        info.topLevelVariables.upsert(personVariable)
        
        var parser = SyntaxParser(infoHandler: info)
        parser.parse(source: code)
        
        let ageName = try #require(info.topLevelVariables.find(named: "ageName"))
        #expect(ageName.type == info.string)
    }
    
    @Test func fullNameOfOptionalType() throws{
        let person : ObjectInformation = .class("Person", using: info)
        
        person.append(.var(name: "name", type: info.string))
        
        #expect(person.fullName == "Person")
        
        let optional = person.optional!
        
        
        #expect(optional.fullName == "Person")
    }
    
    @Test func multiLevelTypeInferanceTest() throws{
        
        let code =
        """
        let mohammad = Person(age: 12)
        let age = mohammad.age
        let ageDecs = mohammad.age.description
        let counter = Person.counter.description
        struct Person { 
        
            var age : Int
        
            var name : String
        
            
            static var counter : Double
        }
        
        let uuid = UUID()
        let myType = RandomType(age : 12, name : 234)
        """
        
        var parser = SyntaxParser(infoHandler: info)
        parser.parse(source: code)
        

        let globals = info.topLevelVariables
        
        let age = try #require(globals.find(named: "age"))
        
        
            
        #expect(age.name == "age")
        #expect(age.type == info.int)
        
        let ageDesc = try #require(globals.find(named: "ageDecs"))
        #expect(ageDesc.name == "ageDecs")
        #expect(ageDesc.type == info.string)
        
        let counter = try #require(globals.find(named: "counter"))
        #expect(counter.name == "counter")
        #expect(counter.type == info.string)
        
        let uuid = try #require(globals.find(named: "uuid"))
        #expect(uuid.name == "uuid")
        #expect(uuid.type == info.uuid)
        
        let myType = try #require(globals.find(named: "myType"))
        #expect(myType.name == "myType")
        #expect(myType.type == info.find("RandomType"))
    }
}
