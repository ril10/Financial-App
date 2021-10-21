//
//  TestViewControllerTableView.swift
//  Financial AppTests
//
//  Created by administrator on 21.10.21.
//

import XCTest
@testable import Financial_App
class TestViewControllerTableView: XCTestCase {

    
    var sut : ViewController!
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ViewController()
        self.sut.loadView()
        self.sut.viewDidLoad()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHasTableView() throws {
        XCTAssertNotNil(sut.tableView.delegate)
    }
    
    func testTableViewHasDelegate() throws {
        XCTAssertNotNil(sut.tableView.delegate)
    }
    
    func testTableViewConformsToTableViewDelegate() throws {
        XCTAssertTrue(sut.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(sut.responds(to: #selector(sut.tableView(_:didSelectRowAt:))))
    }
    
    func testTableViewHasDataSource() throws {
        XCTAssertNotNil(sut.tableView.dataSource)
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol() throws {
        XCTAssertTrue(sut.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(sut.responds(to: #selector(sut.numberOfSections(in:))))
        XCTAssertTrue(sut.responds(to: #selector(sut.tableView.numberOfRows(inSection:))))
        XCTAssertTrue(sut.responds(to: #selector(sut.tableView(_:cellForRowAt:))))
    }
    
    func testTableViewCellHasReuseIdentifier() {
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CustomTableViewCell
        let actualReuseId = cell?.reuseIdentifier
        let exceptedReuseId = "CustomTableViewCell"
        XCTAssertEqual(actualReuseId, exceptedReuseId)
    }
    
    func testTableViewCellHasCorrectLabelText() {
        let cell0 = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0 )) as? CustomTableViewCell
        XCTAssertEqual(cell0?.textLabel?.text, "one")
        
        let cell1 = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 1, section: 0 )) as? CustomTableViewCell
        XCTAssertEqual(cell1?.textLabel?.text, "two")
        
        let cell2 = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 2, section: 1 )) as? CustomTableViewCell
        XCTAssertEqual(cell2?.textLabel?.text, "three")
    }
    
    
    

}
