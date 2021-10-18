//
//  Financial_AppTests.swift
//  Financial AppTests
//
//  Created by administrator on 20.09.21.
//

import XCTest
@testable import Financial_App

class Financial_AppTests: XCTestCase {

    var sut : Date!
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = Date()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDateFormatter() throws {
        //given
        let receivedDateTimeInterval = Date().timeIntervalSince1970

        //when
        
        //then
        
    }

}
