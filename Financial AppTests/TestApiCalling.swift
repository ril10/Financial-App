//
//  TestApiCalling.swift
//  Financial AppTests
//
//  Created by administrator on 19.10.21.
//

import XCTest
import RxSwift
@testable import Financial_App
class TestApiCalling: XCTestCase {

    var sut : APICalling!
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = APICalling()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testApiCallingLoadMethod() throws {
        //when
        let requestService = RequestService(apiCalling: APICalling(), apiRequest: APIRequest())
        let request = requestService.requestQuote(symbol: "AAPL")
        //then
        let urlString = "https://finnhub.io/api/v1/quote?symbol=AAPL&token=c5474t2ad3ifdcrdfsmg"
        let requestCustom = sut.load(apiRequest: URLRequest(url: URL(string: urlString)!)) as Observable<Quote>
        //given
        XCTAssertNotIdentical(requestCustom, request)
        XCTAssertNotNil(request)
        XCTAssertNotNil(requestService)
    }
    
}
