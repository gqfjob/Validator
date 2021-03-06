/*

 ValidatableInterfaceElementTests.swift
 Validator

 Created by @adamwaite.

 Copyright (c) 2015 Adam Waite. All rights reserved.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.

*/

import XCTest
@testable import Validator

class ValidatableInterfaceElementTests: XCTestCase {
    
    func testThatItCanValidateInputValues() {
        
        let textField = UITextField()
        textField.text = "Hello"
        
        let rule = ValidationRuleCondition<String>(failureError: ValidationError(message: "💣")) { $0!.characters.contains("A") }
        
        let invalid = textField.validate(rule: rule)
        XCTAssertFalse(invalid.isValid)
        
        textField.text = "Hello Adam"
        
        let valid = textField.validate(rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
    func testThatItCanValidateInputValuesWithMultipleRules() {
        
        let textField = UITextField()
        textField.text = "Hi"
        
        var rules = ValidationRuleSet<String>()
        rules.addRule(ValidationRuleLength(min: 5, failureError: ValidationError(message: "💣")))
        rules.addRule(ValidationRuleCondition<String>(failureError: ValidationError(message: "💣")) { ($0?.characters.contains("A"))! })
        
        let definitelyInvalid = textField.validate(rules: rules)
        XCTAssertFalse(definitelyInvalid.isValid)
        
        textField.text = "Hi adam"
        
        let partiallyInvalid = textField.validate(rules: rules)
        XCTAssertFalse(partiallyInvalid.isValid)
        
        textField.text = "Hi Adam"
        
        let valid = textField.validate(rules: rules)
        XCTAssertTrue(valid.isValid)
        
    }
    
    func testThatItCanValidateWithRulesAttachedToIt() {
        
        let textField = UITextField()
        
        var rules = ValidationRuleSet<String>()
        rules.addRule(ValidationRuleLength(min: 5, failureError: ValidationError(message: "💣")))
        rules.addRule(ValidationRuleCondition<String>(failureError: ValidationError(message: "💣")) { ($0?.characters.contains("A"))! })
        
        textField.validationRules = rules
        
        textField.text = "Hi adam"
        
        let invalid = textField.validate()
        XCTAssertFalse(invalid.isValid)
        
        textField.text = "Hi Adam"

        let valid = textField.validate()
        XCTAssertTrue(valid.isValid)
        
    }
        
}