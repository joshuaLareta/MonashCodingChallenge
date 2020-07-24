//
//  TransportTests.swift
//  Monash-coding-challengeTests
//
//  Created by Joshua on 24/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import XCTest
@testable import Monash_coding_challenge

class TransportTests: XCTestCase {

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
    
    func testValidTransportDataShouldReturnAListOfTransport() {
        manager.requestTransportData(shouldProcessItems: true) // request the data one by one. The request doesn't get immediately process so we need to do it after each request
        XCTAssertFalse(manager.items.isEmpty, "There should be an entry present")
        let item = manager.items.first // get the first entry
        switch item?.section {
        case .transport(let list):
            XCTAssertTrue(list.count == 4, "The total count should be 4")
            XCTAssertFalse(list.isEmpty, "The list should not be empty.")
        default:
            XCTFail("Transport should be the only item present")
        }
    }
    
    /// We are testing if data retrieval is working, as well as making sure that the first item matches what we expect.
    func testValidTransportDataAndCheckIfSpecificTransportExist() {
        manager.requestTransportData(shouldProcessItems: true) // request the data one by one. The request doesn't get immediately process so we need to do it after each request
        XCTAssertFalse(manager.items.isEmpty, "There should be an entry present")
        let item = manager.items.first // get the first entry
        switch item?.section {
        case .transport(let list):
            guard let transport = list.first else {
                XCTFail("The list should not be empty and we should be able to retrieve a transport")
                return
            }
            XCTAssertTrue(transport.from == "Notting hill", "The first entry should be from \"Notting hill\"")
            XCTAssertTrue(transport.to == "Surrey hill", "The first entry should be going \"Surrey hill\"")
            XCTAssertTrue(transport.travelTime == 3600, "The first entry should have a timestamp of \"3600\"")
            XCTAssertTrue(transport.travelTimeDisplay() == "1 hour", "The first entry should have a display of \"1 hour\"")
            
        default:
            XCTFail("Transport should be the only item present")
        }
    }
    
    /// This test the invalid data handling
    func testInvalidTransportData() {
        MockedDataProvider.instance.isValidData = false // We inform the provider to set invalid data. This should be done before the call for data is called
        manager.requestTransportData(shouldProcessItems: true) // request the data one by one. The request doesn't get immediately process so we need to do it after each request
        XCTAssertTrue(manager.items.isEmpty, "There should not be any entry present")
    }

}
