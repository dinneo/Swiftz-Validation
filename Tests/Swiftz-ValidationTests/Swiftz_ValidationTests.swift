//
//  Swiftz_ValidationTests.swift
//  Swiftz-ValidationTests
//
//  Created by Ricardo Pallás on 09/09/2017.
//  Copyright © 2017 Ricardo Pallas. All rights reserved.
//

import XCTest
// MARK: - This import name must be valid swift source file name
@testable import Swiftz_Validation

class Swiftz_ValidationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func isPasswordLongEnough(_ password:String) -> Validation<[String], String> {
        if password.count < 8 {
            return Validation.failure(["Password must have more than 8 characters."])
        } else {
            return Validation.success(password)
        }
    }
    
    func isPasswordStrongEnough(_ password:String) -> Validation<[String], String> {
        if (password.range(of:"[\\W]", options: .regularExpression) != nil){
            return Validation.success(password)
        } else {
            return Validation.failure(["Password must contain a special character."])
        }
    }
    
    //Use case provided by Jesús López
    func isDifferentUserPass(_ user:String, _ password:String) -> Validation<[String], String> {
        if (user == password){
            return Validation.failure(["Username and password MUST be different."])
        } else {
            return Validation.success(password)
        }
    }
    
    func isPasswordValid(user: String, password:String) -> Validation<[String], String> {
        
        return isPasswordLongEnough(password)
            .sconcat(isPasswordStrongEnough(password))
            .sconcat(isDifferentUserPass(user, password))
    }
    
    
    func testApplicative() {
        
        let validation3 = Validation<String, Int>.pure(3)
        let validationAdd2 = Validation<String, (Int) -> Int>.pure({$0 + 2})
        let validation5 = validation3.ap(validationAdd2)
        XCTAssert(validation5.success == 5)
    }
    
    func testAppliativeLiftA(){
        let add2 = { $0 + 2 }
        let validation3 = Validation<String, Int>.pure(3)
        let validation5 = Validation.liftA(add2) (validation3)
        XCTAssert(validation5.success == 5)
    }
    
    func testAppliativeLiftAFailure(){
        let add2 = { $0 + 2 }
        let validation3 = Validation<String, Int>.failure("Error")
        let validation5 = Validation.liftA(add2) (validation3)
        XCTAssert(validation5.success == nil && validation5.failure == "Error")
    }
    
    func testSemigroupFailure(){
        let result = isPasswordValid(user: "Richi", password: "Richi")
        XCTAssert(result.success == nil && result.failure! == ["Password must have more than 8 characters.", "Password must contain a special character.","Username and password MUST be different."])
    }
    
    func testSemigroupSuccess(){
        let result = isPasswordValid(user:"Richi", password: "Ricardo$")
        XCTAssert(result.success == "Ricardo$" && result.failure == nil)
    }
}

