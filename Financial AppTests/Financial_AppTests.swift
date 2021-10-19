//
//  Financial_AppTests.swift
//  Financial AppTests
//
//  Created by administrator on 20.09.21.
//

import XCTest
@testable import Financial_App

class Financial_AppTests: XCTestCase {

    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }

    override func tearDownWithError() throws {
        
        try super.tearDownWithError()
    }
    
    func testGraphLabelDate() throws {
        //given
        let str = 1634569414
        //when
        let test = str.graphLabelDate()
        //then
        XCTAssertEqual("10-18 18:03", test)
    }
    
    func testDateFormatter() throws {
        //given
        let dateTime = Date().dateFormatter()
        //when
        let test = Date().dateFormatter()
        //then
        XCTAssertEqual(dateTime, test )
    }
    

}
