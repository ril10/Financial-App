//
//  TestCoreData.swift
//  Financial AppTests
//
//  Created by administrator on 21.10.21.
//

import XCTest
@testable import Financial_App
import CoreData
class TestCoreData: XCTestCase {


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

    func testFetchByCoreData() throws {
        let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        
        let result = try? context.fetch(fetchRequest)
        XCTAssertEqual(result?.count, 0)
        XCTAssertNotNil(result != nil)
        
    }
    
    func testAddData() throws {
        let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        var listData = [List]()
        let newList = List(context: context)
        newList.name = "UnitTest CoreData"
        listData.append(newList)
        XCTAssertEqual(listData.count, 1)

    }
    
    func testDeleteData() throws {
        let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        var listData = [List]()
        let newList = List(context: context)
        newList.name = "UnitTest CoreData"
        listData.append(newList)
        XCTAssertEqual(listData.count, 1)
        
            for object in listData {
                if object.name == newList.name {
                    context.delete(listData.remove(at: 0))
                    XCTAssertEqual(listData.count, 0)
                }
            }
    }

}
