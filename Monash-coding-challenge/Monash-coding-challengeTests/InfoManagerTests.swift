//
//  InfoManagerTests.swift
//  Monash-coding-challengeTests
//
//  Created by Joshua on 24/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import XCTest
@testable import Monash_coding_challenge

class InfoManagerTests: XCTestCase {
    var manager: InfoManager!
    override func setUp() {
        super.setUp()
        manager = InfoManager()
        
        // assign the data providers to the same mocked data provider
        manager.transportProvider = MockedDataProvider.instance
        manager.scheduleProvider = MockedDataProvider.instance
        manager.carparkProvider = MockedDataProvider.instance
    }
    
    override func tearDown() {
        super.tearDown()
        MockedDataProvider.instance.isValidData = true
        manager = nil
    }
    
    /// We are testing the all request functionality. This should give us all the sections (schedules, carparks, and transport)
    func testInfoManagerRequestAllFunctionShouldReturnAllSections() {
        manager.requestAllData()// request all the data

        XCTAssertFalse(manager.items.isEmpty, "There should be an entry present")
        XCTAssertTrue(manager.totalItems() == 3, "There should be 3 sections present")
        
        // test if carpark section exist
        XCTAssertTrue(manager.items.contains(where: { if case DataSection.carparks = $0.section { return true } else { return false }}), "Carpark section should be avaiable")
        
        // test schedules
        XCTAssertTrue(manager.items.contains(where: { if case DataSection.schedules = $0.section { return true } else { return false }}), "schedules section should be avaiable")
        // test transport
        XCTAssertTrue(manager.items.contains(where: { if case DataSection.transport = $0.section { return true } else { return false }}), "transport section should be avaiable")
       
    }
    
    /// Testing section retrieval using the method `manager.item(atSection:)`. This should give a proper section
    func testInfoManagerFirstTableSectionFetchShouldBeSchedules() {
        manager.requestAllData()// request all the data
        
        XCTAssertFalse(manager.items.isEmpty, "There should be an entry present")
        XCTAssertTrue(manager.totalItems() == 3, "There should be 3 sections present")
        guard let sectionItem = manager.item(atSection: 0) else {
            XCTFail("This should not be nil. There should be a section item present")
            return
        }
        
        switch sectionItem.section {
        case .schedules(let items):
            XCTAssertFalse(items.isEmpty, "Item list should not be nil")
        default:
            XCTFail("Schedules is the first item being processed, so it should be the first one on the list")
        }
        
    }
    
}
