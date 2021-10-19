//
//  TestViewControllerViewModel.swift
//  Financial AppTests
//
//  Created by administrator on 19.10.21.
//

import XCTest
@testable import Financial_App
class TestViewControllerViewModel: XCTestCase {

    var sut : ViewControllerViewModel!
    override func setUpWithError() throws {
       try super.setUpWithError()
       sut = ViewControllerViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
       try super.tearDownWithError()
        sut = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
     
    func testFetchDataViewControllerViewModel() throws {
        //given
        let favorite = [Favorite]()
        //when
        let when = sut.fetchData(fav: favorite)
        //then
        XCTAssertNotNil(when)
        XCTAssertEqual(favorite, [Favorite]())
    }
    

}
