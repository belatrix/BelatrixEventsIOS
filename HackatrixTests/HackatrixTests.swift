//
//  HackatrixTests.swift
//  HackatrixTests
//
//  Created by Erik Fernando Flores Quispe on 8/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import XCTest
@testable import Hackatrix

class HackatrixTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDate() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //2017-05-20T09:00:00Z
        //2017-05-11T14:51:13.560243Z
        XCTAssert("11/05/17 02:51 PM" == Utils.date.getFormatter(dateString: "2017-05-11T14:51:13.560243Z"))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
