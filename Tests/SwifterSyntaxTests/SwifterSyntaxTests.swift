import Testing
@testable import SwifterSyntax
import SwiftSyntax
import SwiftParser
import SwiftSyntaxBuilder
import Foundation

struct ViewModelBuilderTest {

    let helper : SwiftSyntaxHelper
    let info : InformationHandler
    
    init(){
        let info = InformationHandler.new
        helper = SwiftSyntaxHelper(info: info)
        self.info = info
    }
    
    @Test func informationHandlerInitialization() async throws {
        let info = InformationHandler.new
        
        #expect(info.viewModels.isEmpty)
        
        let descriptioin = try #require(info.int.fields.find(named: "description"))
       
        #expect(descriptioin.type == info.string)
        #expect(descriptioin.isComputedProperty == true)
    }
    
    @Test func arrayAndOptionalTypesGeneration() throws {
        
        let person = ObjectInformation.struct("Person", using: info)
        
        let name : FeildType = .var(name: "name", type: info.string, initialValue: "Mohammad")
        
        let family : FeildType = .var(name: "family", type: info.string, initialValue: nil)
        
        let age : FeildType = .let(name: "age", type: info.int, initialValue: 14)
        
        person.append([name,family,age])
        
        person.conformances.upsert("Equatable")
        
        info.append(person)
      
            
        //Optional : Person?
        let optionalInfo = try #require(person.optional)
        
        
        
        
        #expect(optionalInfo.name == "Person?" )
        #expect(optionalInfo.isOptional)
        #expect(optionalInfo.fields.map(\.id).ascending() == person.fields.map(\.id).ascending() )
        
        #expect(optionalInfo.fields == person.fields)
        //Array : [Person]
        let personArray = try #require(person.array)
        
        #expect(personArray.isArray)
        #expect(personArray.name == "[Person]")
        
        let arrayFeilds = personArray.fields
        
        let first = try #require(arrayFeilds.first(where: {$0.name == "first"}))
        let last = try #require(arrayFeilds.first(where: {$0.name == "last"}))
        
        let firstType = try #require(first.type)
        #expect(first.type == person.optional)
        #expect(firstType.isOptional)
        
        #expect(last.type == person.optional)
        #expect(last.type!.isOptional)
        
        //Array of Optionals : [Person?]
        let optionalPersonArray = try #require(person.arrayOfOptionals)
        
        #expect(optionalPersonArray.isArray)
        #expect(optionalPersonArray.name == "[Person?]")
        let firstMember = try #require(optionalPersonArray.findVariable(named: "first"))
        #expect(firstMember.type == person.optional)
        
        //Optional Array : [Person]?
        let optionalArray = try #require(person.optionalArray)
        #expect(optionalArray.isOptional)
        #expect(optionalArray.isArray)
        #expect(optionalArray.name == "[Person]?")
        let fistMemberOptionalArray = try #require(optionalArray.findVariable(named: "first"))
        #expect(fistMemberOptionalArray.type == person.optional)
        
        //Optional Array of Optionals : [Person?]?
        let optionalArrayOfOptionals = try #require(person.optionalArrayOfOptionals)
        #expect(optionalArrayOfOptionals.isOptional)
        #expect(optionalArrayOfOptionals.isArray)
        #expect(optionalArrayOfOptionals.name == "[Person?]?")
        let fistMemberOptionalArray2 = try #require(optionalArray.findVariable(named: "first"))
        #expect(fistMemberOptionalArray2.type == person.optional)
        
        //Test if creating an array from an optional type is equal to creating an optionalArray from base type
        let optionalArray2 = try #require(person.optional?.array)
        let optionalArray3 = try #require(person.arrayOfOptionals)
        
        #expect(optionalArray2 == optionalArray3)
        #expect(optionalArray2.name == "[Person?]")
        #expect(optionalArray3.name == "[Person?]")
        
        //Creating an optional-array of an optional type : Person?.optionalArray -> [Person?]?
        //must be equal to creating an optional array of optionals of the base type : Person.optionalArrayOfOptionals -> [Person?]?
        let created = try #require(optionalInfo.optionalArray)
        #expect(created == optionalArrayOfOptionals)
        
    }
    
    @Test func testEnvironmentVariablesType() async throws {
    
        //source code to be tested
        let sampleCode = "@Environment(Coordinator.self) private var coordinator"
 
        
        
        var parser = SyntaxParser(infoHandler: info)
        parser.parse(source: sampleCode)
        
       
        
        let variableInfo = try #require(try info.topLevelVariables.find(named: "coordinator"))
        
        #expect(variableInfo.name == "coordinator")
        #expect(variableInfo.isComputedProperty == false)
        #expect(variableInfo.accessLevel == .private)
        #expect(variableInfo.attributes.contains("@Environment"))
        #expect(variableInfo.mutationType == .var)
        #expect(variableInfo.isStatic == false)
        #expect(variableInfo.type == info.find("Coordinator"))
    }
    
    @Test func testAccessLevelCodeGeneration() async throws {
        var variable : FeildType = .var(name: "name", type: info.string)
        
        variable.accessLevel = .private
        variable.accessLevel.parentAccessLevel = .public
        
        var expected = "private var name : String"
        var code = variable.code
        
        #expect(expected == code)
        
        variable = .var(name: "age", type: info.int, initialValue: 24)
        
        variable.accessLevel = .public
        variable.accessLevel.parentAccessLevel = .public
        
        expected = "var age : Int = 24"
        code = variable.code
        
        #expect(code == expected)
        
        variable.accessLevel = .unknown
        variable.accessLevel.parentAccessLevel = .internal
        
        code = variable.code
        //expected is the same
        
        #expect(code == expected)
        
        variable.accessLevel = .internal
        variable.accessLevel.parentAccessLevel = nil
        
        code = variable.code
        //expected is the same
        
        #expect(code == expected)
        
        variable.accessLevel = .unknown
        
        code = variable.code
        //expected is the same
        
        #expect(code == expected)
        
        variable.accessLevel = .public
        
        code = variable.code
        expected = "public var age : Int = 24"
        
        #expect(code == expected)
    }
    @Test func testCodeGenerationForVariables() async throws {
        let variableSample = FeildType(name: "name", type: info.string, attributes: [], mutationType: .var, initialValue: "Mohammad", isComputedProperty: false, modifiers: [], accessLevel: .private)
        
        let generatedCode = variableSample.code
        
        #expect(generatedCode == "private var name : String = \"Mohammad\"")
        
        let variableSample2 : FeildType = .var(name: "name", type: info.bool, initialValue: "false")
        
        let generatedCode2 = variableSample2.code
        
        #expect(generatedCode2 == "var name : Bool = false")
        
        let coordinatorType : ObjectInformation = .class("Coordinator", using: info)
        let environmentVariableSample : FeildType = .environment(name: "coordinator", type: coordinatorType)
        
        
        
        let generatedEnvironmentVariableCode = environmentVariableSample.code
        
        #expect(generatedEnvironmentVariableCode == "@Environment(Coordinator.self) private var coordinator")
        
        let source = " let age = currentDate - dateOfBirth\nreturn age"
        let computed : FeildType = .computedProperty(name: "age", type: info.int, source: source)
        
        let code = computed.code
        let expected = "var age : Int {\n\(source.indented)\n}\n"
        
        #expect(code == expected)
    }
    
    @Test("Code generation for function") func codeGenerationForFunction() async throws {
        
        //creating mock type
        let userType : ObjectInformation = .fromString("User", using: info)
        
        //creating function
        let function = FunctionInformation(name: "createUser",
                                           intputTypes: [
                                                .init(name: "from", secondName: "name", type: info.string),
                                                .init(name: "age", type: info.int),
                                            ],
                                           returnType: userType)
        function.modifiers = ["static" , "mutating"]
        function.accessLevel = .fileprivate
        function.isThrowing = true
        function.innerSourceCode = "    //some code in here"
        function.isAsync = true
        function.parent = nil
        
        //generating code
        let code = function.code
        
        //testing
        let expected = """
        static mutating fileprivate func createUser(from name : String, age : Int) async throws -> User{
            //some code in here
        }
        """
        #expect(code == expected)
        #expect(function.isGlobal == true)
    }
    
    @Test("Code generation for extensions") func codeGenerationForExtension() async throws {
        let userType : ObjectInformation = .fromString("User", using: info)

        var extensionInfo : ExtensionInformation
        extensionInfo = ExtensionInformation(of: userType)
        extensionInfo.accessLevel = .fileprivate
        
        let variable1 : FeildType = .computedProperty(name: "familyName", type: info.string)
        let variable2 : FeildType = .computedProperty(name: "fullName", type: info.string)
        
        let function1 = FunctionInformation(name: "getName", intputTypes: [],returnType: info.string)
        function1.accessLevel = .fileprivate
        
        let function2 = FunctionInformation(name: "setName", intputTypes: [.init(name: "name", type: info.string)])
        function2.accessLevel = .public
        
        extensionInfo.append(function1)
        extensionInfo.append(function2)
        extensionInfo.append(variable1)
        extensionInfo.append(variable2)
        
        let code = extensionInfo.code
        
        let expectedCoded = """
        fileprivate extension User{
            var familyName : String{
            }
            var fullName : String{
            }
        
        """
        
    }
    
    @Test("UniqueArray type test") func uniqueArray() async throws {
        struct Person : Identifiable {
            let id : UUID = UUID()
            let name : String
        }
        
        let array : UniqueArray<Person> = [.init(name: "Mina"), .init(name: "Atena") , .init(name: "Piruz")]
        
        let count = array.count
        #expect(count == 3)
        
        #expect(array.first!.name == "Mina")
        #expect(array.last?.name == "Piruz")
        
        
    }
    
    @Test("Initializer code generation test")
    func initializerCodeGenerationTest() async throws {
        let initializers = InitializerType(for: info.string)
        
        initializers.isAsync = true
        initializers.isThrowing = true
        initializers.isNullable = true
        initializers.accessLevel = .fileprivate
        initializers.innerSourceCode = "age = 12" //not important
        initializers.inputs = [.init(name: "test", type: info.double)]
        initializers.modifiers = ["lazy"]
        
        var code = initializers.code
        var expected = """
        fileprivate lazy init?(test : Double) async throws{
        \tage = 12
        }
        
        """
        #expect(code == expected )
        
        initializers.isAsync = false
        code = initializers.code
        expected = """
        fileprivate lazy init?(test : Double) throws{
        \tage = 12
        }
        
        """
        #expect(code == expected )
        
        initializers.isThrowing = false
        code = initializers.code
        expected = """
        fileprivate lazy init?(test : Double){
        \tage = 12
        }
        
        """
        #expect(code == expected )
        
        initializers.isNullable = false
        code = initializers.code
        expected = """
        fileprivate lazy init(test : Double){
        \tage = 12
        }
        
        """
        #expect(code == expected )
        
        initializers.modifiers = []
        code = initializers.code
        expected = """
        fileprivate init(test : Double){
        \tage = 12
        }
        
        """
        #expect(code == expected )
        
        initializers.accessLevel = .internal
        code = initializers.code
        expected = """
        init(test : Double){
        \tage = 12
        }
        
        """
        #expect(code == expected )
        
        initializers.inputs = []
        code = initializers.code
        expected = """
        init(){
        \tage = 12
        }
        
        """
        #expect(code == expected )
       
        initializers.innerSourceCode = nil
        code = initializers.code
        expected = """
        init(){}
        
        """
        #expect(code == expected )
        
        initializers.innerSourceCode = ""
        code = initializers.code
        expected = """
        init(){}
        
        """
        #expect(code == expected )
    }
    
    @Test func typeInferanceTest() async throws {
        let sampleCode = "var age = 12.description"
        
        
        var parser = SyntaxParser(infoHandler: info)
        parser.parse(source: sampleCode)
        
        let variable = try #require(info.topLevelVariables.first)
        
        #expect(variable.type == info.string)
        #expect(variable.name == "age")
        #expect(variable.isOptional == false)
        #expect(variable.isComputedProperty == false)
        #expect(variable.modifiers.isEmpty)
        #expect(variable.accessLevel == .unknown)
        #expect(variable.isStatic == false)
        #expect(variable.isArray == false)
        #expect(variable.initialValue == nil)
        
        let sampleCode2 = "private lazy var isOk = false"
        let newInfo = InformationHandler.new
        var parser2 = SyntaxParser(infoHandler: newInfo)
        parser2.parse(source: sampleCode2)
        
        let variable2 = try #require(newInfo.topLevelVariables.first)
        
        #expect(variable2.type == newInfo.bool)
        #expect(variable2.name == "isOk")
        #expect(variable2.isOptional == false)
        #expect(variable2.isComputedProperty == false)
        #expect(variable2.modifiers == ["lazy"])
        #expect(variable2.accessLevel == .private)
        #expect(variable2.isStatic == false)
        #expect(variable2.isArray == false)
        
    }
    

    
    @Test func inputLitteralInitializationTest() {
        
        //true
        let trueValue : InputLitteral = "true"
        #expect(trueValue == .true)
        let trueValue2 : InputLitteral = .true
        #expect(trueValue2 == .true)
        let trueValue3 : InputLitteral = true
        #expect(trueValue3 == .true)
        
        //false
        let falseValue : InputLitteral = "false"
        #expect(falseValue == .false)
        let falseValue2 : InputLitteral = .false
        #expect(falseValue2 == .false)
        let falseValue3 : InputLitteral = false
        #expect(falseValue3 == .false)
        
        //nil
        let nilValue : InputLitteral = "nil"
        #expect(nilValue == .nil)
        let nilValue2 : InputLitteral? = nil
        #expect(nilValue2 == nil)
        
        //array
        let arrayValue : InputLitteral = "[1,2,3]"
        #expect(arrayValue == .array("[1,2,3]"))
        
        //string
        let stringValue : InputLitteral = "Hello World"
        #expect(stringValue == .string("Hello World"))
        let testString = "Mohammad"
        
        let stringValue2 : InputLitteral = .from(testString)
        #expect(stringValue2 == .string(testString))
        
        let stringValue3 = "MyName".litteral
        #expect(stringValue3 == .string("MyName"))
        
        let stringValue4 : InputLitteral = .init(exact: "nil")
        #expect(stringValue4 == .string("nil"))
        
        
        
        //int
        let intValue : InputLitteral = 10
        #expect(intValue == .int(10))
        
        //double
        let doubleValue : InputLitteral = 12.34
        #expect(doubleValue == .double(12.34))
        
        
    }
    
    @Test func inputLitteralGeneratedCodeAndValueTest() {
        let stringSample = "Hello, World!"
        let litteral = stringSample.litteral
        #expect(litteral.code == "\"Hello, World!\"")
        #expect(litteral.value == "Hello, World!")
        
        #expect("nil".litteral.code == "nil")
        #expect("nil".litteral.value == "nil")
        
        #expect(false.litteral.code == "false")
        #expect(false.litteral.value == "false")
        
        #expect(true.litteral.code == "true")
        #expect(true.litteral.value == "true")
        
        #expect(123.litteral.code == "123")
        #expect(123.litteral.value == "123")
        
        #expect(123.456.litteral.code == "123.456")
        #expect(123.456.litteral.value == "123.456")
        
        let arraysample = "[1, 2, 3]".litteral
        #expect(arraysample.code == "[1, 2, 3]")
        #expect(arraysample.value == "[1, 2, 3]")
        
        let arraySample2 = InputLitteral.array("1,2,3")
        #expect(arraySample2.code == "[1,2,3]")
        #expect(arraySample2.value == "1,2,3")
        
    }
}
