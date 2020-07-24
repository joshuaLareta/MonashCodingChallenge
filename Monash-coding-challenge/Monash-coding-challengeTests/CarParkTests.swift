//
//  CarParkTests.swift
//  Monash-coding-challengeTests
//
//  Created by Joshua on 24/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import XCTest
@testable import Monash_coding_challenge

class CarParkTests: XCTestCase {
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
    
    /// Test that we can retrieve list of carparks
    func testValidCarParkDataShouldReturnAListOfCarParks() {
        manager.requestCarParkData(shouldProcessItems: true) // request the data one by one. The request doesn't get immediately process so we need to do it after each request
        XCTAssertFalse(manager.items.isEmpty, "There should be an entry present")
        let item = manager.items.first // get the first entry
        switch item?.section {
        case .carparks(let list):
            XCTAssertTrue(list.count == 4, "The total count should be 4")
            XCTAssertFalse(list.isEmpty, "The list should not be empty.")
        default:
            XCTFail("Carparks should be the only item present")
        }
    }
    
    /// Test that a specific carpark from our mock service exist
    func testValidCarParkDataAndCheckIfSpecificCarParkExist() {
        manager.requestCarParkData(shouldProcessItems: true) // request the data one by one. The request doesn't get immediately process so we need to do it after each request
        XCTAssertFalse(manager.items.isEmpty, "There should be an entry present")
        let item = manager.items.first // get the first entry
        switch item?.section {
        case .carparks(let list):
            guard let carPark = list.first else {
                XCTFail("The list should not be empty and we should be able to retrieve a CarPark detail")
                return
            }
            XCTAssertTrue(carPark.location == "Notting hill", "The first entry should have a location of \"Notting hill\"")
            XCTAssertTrue(carPark.available == 1, "The first entry should have an availability of \"1\"")
            XCTAssertTrue(carPark.total == 20, "The first entry should have a total of \"20\"")
            
        default:
            XCTFail("carPark should be the only item present")
        }
    }
    
    /// test invalid data
    func testInvalidCarParkData() {
        MockedDataProvider.instance.isValidData = false // We inform the provider to set invalid data. This should be done before the call for data is called
        manager.requestCarParkData(shouldProcessItems: true) // request the data one by one. The request doesn't get immediately process so we need to do it after each request
        XCTAssertTrue(manager.items.isEmpty, "There should not be any entry present")
    }
}
