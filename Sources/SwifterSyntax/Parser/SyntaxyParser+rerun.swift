//
//  SyntaxyParser+rerun.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/1/25.
//

extension SyntaxParser {
    ///Rerun the parser, if needed
    ///
    ///Because when we are inferring types, we parse source code in order,
    ///the order of files might affect our inference.
    ///
    /// for example:
    ///
    ///file1 :
    ///```swift
    ///var personName = myPerson.name
    ///```
    ///file2:
    ///```swift
    ///struct Person{
    ///  var name : String
    ///}
    ///var myPerson = Person(name : "Mohammad")
    ///```
    ///if we parse `file2` first, then by the time we reach `file1` we already know `myPerson`s type thus
    ///we can infer `personName` type, but if we parse `file1` first, then `file2`, we can't infer the type of
    ///`personName` variable cause `myPerson` is not visited yet.
    ///
    ///to go around this problem, on the first run, if we can't infer the type of a variable it will be nil
    /// then we parse the entire code a second time (using the same `InformationHandler`, thus keeping our previous knowledge).
    /// this trick will make the order of files irrelevant.
    func reRun() {
        
        guard enableRerun else { return }
        guard self.infoHandler.needRerun else { return }
        
        logger.info("Reruning visitors...")
        
        //since reRun is only for type inference , and the only thing that it's type
        //is implicit is variables, we only call VariableVisitor in here
        let visitor = VariablesVisitor(info: infoHandler, mode: .all)
        
        infoHandler.codesToRerun.forEach {
            visitor.run(with:$0)
        }
        
        self.infoHandler.needRerun = false
    }
}
