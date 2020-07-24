//
//  ScheduleTests.swift
//  Monash-coding-challengeTests
//
//  Created by Joshua on 22/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import XCTest
@testable import Monash_coding_challenge

class ScheduleTests: XCTestCase {

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
    
    /// Test that we can actually retrieve the data from mock services
    func testValidScheduleDataShouldReturnAListOfSchedule() {
        manager.requestSchedules(shouldProcessItems: true) // request the data one by one. The request doesn't get immediately process so we need to do it after each request
        XCTAssertFalse(manager.items.isEmpty, "There should be an entry present")
        let item = manager.items.first // get the first entry
        switch item?.section {
        case .schedules(let list):
            XCTAssertTrue(list.count == 4, "The total count should be 4")
            XCTAssertFalse(list.isEmpty, "The list should not be empty.")
        default:
            XCTFail("Schedules should be the only item present")
        }
    }
    
    /// Test if a specific schedule exist. This guarantees that the retrieval of the item works
    func testValidScheduleDataAndCheckIfSpecificScheduleExist() {
        manager.requestSchedules(shouldProcessItems: true) // request the data one by one. The request doesn't get immediately process so we need to do it after each request
        XCTAssertFalse(manager.items.isEmpty, "There should be an entry present")
        let item = manager.items.first // get the first entry
        switch item?.section {
        case .schedules(let list):
            guard let schedule = list.first else {
                XCTFail("The list should not be empty and we should be able to retrieve a schedule")
                return
            }
            XCTAssertTrue(schedule.subject == "Art 101: Art class", "The first entry should have a subject of \"Art 101: Art class\"")
            XCTAssertTrue(schedule.educator == "John Doe", "The first entry should have an educator of \"John Doe\"")
            XCTAssertTrue(schedule.location == "Surrey hills", "The first entry should have a location of \"Surrey hills\"")
            
        default:
            XCTFail("Schedules should be the only item present")
        }
    }
    
    /// This test uses date filter to make sure that we can retrieve proper data from different date
    func testSceduleDataFilterBasedFromNextDate() {
        manager.requestSchedules(shouldProcessItems: true) // request the data one by one. The request doesn't get immediately process so we need to do it after each request
        // We have 2 entries for next day
        let currentDate = Date()
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
        manager.filterScheduleForDate(nextDay) // gets the next schedules
        XCTAssertFalse(manager.items.isEmpty, "There should be an entry present")
        let item = manager.items.first // get the first entry
        switch item?.section {
        case .schedules(let list):
            guard let schedule = list.first else {
                XCTFail("The list should not be empty and we should be able to retrieve a schedule")
                return
            }
            XCTAssertTrue(schedule.subject == "Art 103: Art class", "The first entry should have a subject of \"Art 103: Art class\"")
            XCTAssertTrue(schedule.educator == "Jane Doe", "The first entry should have an educator of \"John Doe\"")
            XCTAssertTrue(schedule.location == "Box hill", "The first entry should have a location of \"Surrey hills\"")
            
        default:
            XCTFail("Schedules should be the only item present")
        }
    }
    
    /// This test uses date filter to make sure that we can retrieve proper data from today's date
    func testSceduleDataFilterBasedFromTodaysDate() {
        manager.requestSchedules(shouldProcessItems: true) // request the data one by one. The request doesn't get immediately process so we need to do it after each request
        let currentDate = Date()
        manager.filterScheduleForDate(currentDate) // gets the next schedules
        XCTAssertFalse(manager.items.isEmpty, "There should be an entry present")
        let item = manager.items.first // get the first entry
        switch item?.section {
        case .schedules(let list):
            guard let schedule = list.first else {
                XCTFail("The list should not be empty and we should be able to retrieve a schedule")
                return
            }
            XCTAssertTrue(schedule.subject == "Art 101: Art class", "The first entry should have a subject of \"Art 101: Art class\"")
            XCTAssertTrue(schedule.educator == "John Doe", "The first entry should have an educator of \"John Doe\"")
            XCTAssertTrue(schedule.location == "Surrey hills", "The first entry should have a location of \"Surrey hills\"")
            
        default:
            XCTFail("Schedules should be the only item present")
        }
    }
    
    
    /// Test for invalid date handling
    func testInvalidScheduleData() {
        MockedDataProvider.instance.isValidData = false // We inform the provider to set invalid data. This should be done before the call for data is called
        manager.requestSchedules(shouldProcessItems: true) // request the data one by one. The request doesn't get immediately process so we need to do it after each request
        XCTAssertTrue(manager.items.isEmpty, "There should not be any entry present")
    }
}
