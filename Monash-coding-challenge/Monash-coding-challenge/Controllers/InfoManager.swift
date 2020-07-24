//
//  InfoManager.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 22/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

class InfoManager {
    typealias NeedsRefreshBlock = () -> Void
    var userProvider: UserDataProvider = UserDataProvider() // assign the data provider
    var scheduleProvider: ScheduleDataProvider = ScheduleDataProvider()
    var carparkProvider: CarParkDataProvider = CarParkDataProvider()
    var transportProvider: TransportDataProvider = TransportDataProvider()
    
    var needsRefreshBlock: NeedsRefreshBlock?
    
    private var schedules: [ClassSchedule] = []
    private var user: User?
    private var carparks: [Carpark] = []
    private var transport: [Transport] = []
    
    var items: [TableSections] = []
    
    init() {
       requestAllData()
        // Request this should not be here, for the sake of this test we'll call it as soon as we initialized the managaer
    }
    
    
}

extension InfoManager {
    private func processItems() {
        items.removeAll()
        if schedules.isEmpty == false {
            items.append(TableSections(section: .schedules(schedules)))
        }
        
        if carparks.isEmpty == false {
            items.append(TableSections(section: .carparks(carparks)))
        }
        if transport.isEmpty == false {
            items.append(TableSections(section: .transport(transport)))
        }
        needsRefreshBlock?()
    }
}

extension InfoManager {
    
    func requestAllData() {
        requestSchedules()
        requestUserData()
        requestCarParkData()
        requestTransportData()
        processItems()
    }
    
    // Fetches all the schedules
    func requestSchedules() {
        scheduleProvider.requestData { [weak self] (data, error) in
             guard let `self` = self else { return }
            // log error or show it to the user
            if let error = error {
                print(error.localizedDescription)
            }
            self.schedules = data ?? []
        }
    }
    
    // Fetches user data
    func requestUserData() {
        userProvider.requestData { [weak self] data, error in
            guard let `self` = self else { return }
            // log error or show it to the user
            if let error = error {
                print(error.localizedDescription)
            }
            self.user = data
        }
    }
    
    func requestCarParkData() {
        carparkProvider.requestData { [weak self] (data, error) in
            guard let `self` = self else { return }
            // log error or show it to the user
            if let error = error {
                print(error.localizedDescription)
            }
            self.carparks = data ?? []
        }
    }
    
    func requestTransportData() {
        transportProvider.requestData { [weak self] (data, error) in
            guard let `self` = self else { return }
            // log error or show it to the user
            if let error = error {
                print(error.localizedDescription)
            }
            self.transport = data ?? []
        }
    }
}


extension InfoManager {
    func getUserName() -> String? {
        guard let name = user?.name else { return nil }
        return String(format: NSLocalizedString("Hey, %@", comment: "Hey, <username>"), name)
    }
    
    func getCurrentDate() -> String? {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM EEEE"
        let dateString = dateFormatter.string(from: currentDate)
        guard let semesterWeek = user?.semesterWeek else { return dateString }
        return String(format:"%@, week %d", dateString, semesterWeek)
    }
}

extension InfoManager {
    func totalItems() -> Int {
        return items.count
    }
    
    func numberOfItems(atSection section: Int) -> Int {
        guard items.count > section else { return 0 }
        let item = items[section]
        return item.itemCount
    }
    
    func item(atSection section: Int) -> TableSections? {
        guard items.count > section else { return nil }
        return items[section]
    }
}
