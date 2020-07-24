//
//  MockedDataProvider.swift
//  Monash-coding-challengeTests
//
//  Created by Joshua on 24/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import XCTest
@testable import Monash_coding_challenge

class MockedDataProvider: ScheduleDataProviderProtocol & TransportDataProviderProtocol & CarParkDataProviderProtocol {
    
    static let instance = MockedDataProvider()
     
    var isValidData: Bool = true
    
    var schedules: [ClassSchedule] = []
    var carparks: [Carpark] = []
    var transports: [Transport] = []
    
    private init() {}
    
    func requestAll() {
        MockedDataProvider.instance.requestCarParkData { [weak self] data, error in
            guard let `self` = self else { return }
            self.carparks = data ?? []
        }
        
        MockedDataProvider.instance.requestScheduleData { [weak self] data, error in
            guard let `self` = self else { return }
            self.schedules = data ?? []
            
        }
        
        MockedDataProvider.instance.requestTransportData {  [weak self] data, error in
            guard let `self` = self else { return }
            self.transports = data ?? []
        }
    }
    
}

extension MockedDataProvider {
    private func scheduleData() -> [ClassSchedule]? {
        guard isValidData == true else { return nil }
        let currentDate = Date()
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        return [
            ClassSchedule(start: currentDate,
                          end: Calendar.current.date(byAdding: .hour, value: 1, to: currentDate),
                          subject: "Art 101: Art class",
                          educator: "John Doe",
                          location: "Surrey hills"),
            ClassSchedule(start: Calendar.current.date(byAdding: .hour, value: 2, to: currentDate),
                          end: Calendar.current.date(byAdding: .hour, value: 3, to: currentDate),
                          subject: "Art 102: Art class",
                          educator: "John",
                          location: "Surrey hills, 1234"),
            ClassSchedule(start: Calendar.current.date(byAdding: .hour, value: 1, to: nextDay),
                          end: Calendar.current.date(byAdding: .hour, value: 2, to: nextDay),
                          subject: "Art 103: Art class",
                          educator: "Jane Doe",
                          location: "Box hill"),
            ClassSchedule(start: Calendar.current.date(byAdding: .hour, value: 3, to: nextDay),
                          end: Calendar.current.date(byAdding: .hour, value: 4, to: nextDay),
                          subject: "Math 101: Calculus",
                          educator: "Jane",
                          location: "Notting hill")
            
        ]
       
    }
    
    private func carParkData() -> [Carpark]? {
        guard isValidData == true else { return nil }
        return [
            Carpark(location: "Notting hill", total: 20, available: 1),
            Carpark(location: "Clayton parking lot", total: 1, available: 0),
            Carpark(location: "Manchester lot", total: 200, available: 10),
            Carpark(location: "Mornington pier", total: 300, available: 300),
        ]
    }
    
    private func transportData() -> [Transport]? {
        guard isValidData == true else { return nil }
        return [
                Transport(from: "Notting hill", to: "Surrey hill", travelTime: 3600),
                Transport(from: "San Francisco", to: "United Kingdom", travelTime: 57_600),
                Transport(from: "Melbourne", to: "Clayton", travelTime: 1200),
                Transport(from: "Melbourne", to: "Geelong", travelTime: 3000),
               ]
    }
    
}

extension MockedDataProvider {
    func requestScheduleData(_ completion: ScheduleRequestCompletion?) {
        completion?(scheduleData(), nil)
    }
    
    func requestTransportData(_ completion: TransportRequestCompletion?) {
         completion?(transportData(), nil)
    }
    
    func requestCarParkData(_ completion: CarParkRequestCompletion?) {
         completion?(carParkData(), nil)
    }
}
