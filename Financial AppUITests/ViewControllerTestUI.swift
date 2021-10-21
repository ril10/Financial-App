//
//  ViewControllerTestUI.swift
//  Financial AppUITests
//
//  Created by administrator on 19.10.21.
//

import XCTest

class ViewControllerTestUI: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testViewController() throws {
        
        let app = XCUIApplication()
        let cellLabelName = app.navigationBars["T"].buttons["Main"]
        let userAccount = app.navigationBars["Financial_App.UserAccount"].buttons["My loats"]
        
        //then
        if cellLabelName.exists {
            XCTAssertTrue(cellLabelName.exists)
        } else if userAccount.exists {
            XCTAssertTrue(userAccount.isEnabled)
        }
        
    }
    
    func testCoordinateView() throws {
        
    }
    
    func testUserAccount() throws {
        
        let tablesQuery = XCUIApplication().tables
        let diffVal = tablesQuery/*@START_MENU_TOKEN@*/.cells.staticTexts["4.20%"]/*[[".cells.staticTexts[\"4.20%\"]",".staticTexts[\"4.20%\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        let dateValue = tablesQuery/*@START_MENU_TOKEN@*/.cells.staticTexts["10-19-2021 11:13"]/*[[".cells.staticTexts[\"10-19-2021 11:13\"]",".staticTexts[\"10-19-2021 11:13\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        
        if diffVal.exists {
            XCTAssertNil(diffVal.exists)
            XCTAssertNotNil(diffVal.value)
        }
        if dateValue.exists {
            XCTAssertTrue(dateValue.exists)
        }
        
                        
    }
    
}
