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
    var scheduleProvider: ScheduleDataProviderProtocol = ScheduleDataProvider()
    var carparkProvider: CarParkDataProviderProtocol = CarParkDataProvider()
    var transportProvider: TransportDataProviderProtocol = TransportDataProvider()
    
    var needsRefreshBlock: NeedsRefreshBlock?
    
    private var schedules: [ClassSchedule] = []
    private var user: User?
    private var carparks: [Carpark] = []
    private var transport: [Transport] = []
    
    var items: [TableSections] = []
    
    init() {}
}

extension InfoManager {
    /// Private method that handles the processing, allocation and calling of refresh block for the viewController. We don't use the instance variable so we have the opportunity to modify those things if we want to filter
    ///
    /// - Parameters:
    ///   - scheds   : A list of `ClassSchedule`
    ///   - carLots : I'm bad at naming so let's just call it car lots. This is the list of carpark.
    ///   - transpo : Again bad at naming, but this is the list of `Transport`
    private func processItems(scheds: [ClassSchedule], carLots: [Carpark], transpo: [Transport]) {
        items.removeAll()
        if scheds.isEmpty == false {
            // We sort things out first based on start date
            let sorted = scheds.sorted(by: { sched1, sched2 -> Bool in
                guard let date1 = sched1.start, let date2 = sched2.start else { return true }
                return date1 < date2
            })
            items.append(TableSections(section: .schedules(sorted)))
        }
        
        if carLots.isEmpty == false {
            items.append(TableSections(section: .carparks(carLots)))
        }
        if transpo.isEmpty == false {
            items.append(TableSections(section: .transport(transpo)))
        }
        needsRefreshBlock?()
    }
}

extension InfoManager {
    
    /// Method that requests all the data to all the data provider
    func requestAllData() {
        requestSchedules()
        requestUserData()
        requestCarParkData()
        requestTransportData()
        processItems(scheds: schedules, carLots: carparks, transpo: transport)
    }
    
    /// Fetches all the schedules.
    /// - Parameter shouldProcessItems: This lets the process item be called immediately after the request finishes.
    func requestSchedules(shouldProcessItems: Bool = false) {
        scheduleProvider.requestScheduleData { [weak self] (data, error) in
             guard let `self` = self else { return }
            // log error or show it to the user
            if let error = error {
                print(error.localizedDescription)
            }
            self.schedules = data ?? []
            if shouldProcessItems {
                self.processItems(scheds: self.schedules, carLots: self.carparks, transpo: self.transport)
            }
        }
    }
    
    // Fetches user data
    func requestUserData() {
        userProvider.requestUserData { [weak self] data, error in
            guard let `self` = self else { return }
            // log error or show it to the user
            if let error = error {
                print(error.localizedDescription)
            }
            self.user = data
        }
    }
    
    /// Fetches all the car park list.
    /// - Parameter shouldProcessItems: This lets the process item be called immediately after the request finishes.
    func requestCarParkData(shouldProcessItems: Bool = false) {
        carparkProvider.requestCarParkData { [weak self] (data, error) in
            guard let `self` = self else { return }
            // log error or show it to the user
            if let error = error {
                print(error.localizedDescription)
            }
            self.carparks = data ?? []
            if shouldProcessItems {
                self.processItems(scheds: self.schedules, carLots: self.carparks, transpo: self.transport)
            }
        }
    }
    
    /// Fetches all the transport list.
    /// - Parameter shouldProcessItems: This lets the process item be called immediately after the request finishes.
    func requestTransportData(shouldProcessItems: Bool = false) {
        transportProvider.requestTransportData { [weak self] (data, error) in
            guard let `self` = self else { return }
            // log error or show it to the user
            if let error = error {
                print(error.localizedDescription)
            }
            self.transport = data ?? []
            if shouldProcessItems {
                self.processItems(scheds: self.schedules, carLots: self.carparks, transpo: self.transport)
            }
        }
    }
}

extension InfoManager {
    
    /// Retrieves the current logged in user
    func getUserName() -> String? {
        guard let name = user?.name else { return nil }
        return String(format: NSLocalizedString("Hey, %@", comment: "Hey, <username>"), name)
    }
    
    /// Get the current date with a dd format, with an option of showing the semester week if possible
    func getCurrentDate() -> String? {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM EEEE"
        let dateString = dateFormatter.string(from: currentDate)
        guard let semesterWeek = user?.semesterWeek else { return dateString }
        return String(format:"%@, week %d", dateString, semesterWeek)
    }
    
    /// Method that filters a schedule list to the given date. If nothing is passed falls to the regular list fetched from server
    func filterScheduleForDate(_ date: Date?) {
        guard let date = date else {
            self.processItems(scheds: self.schedules, carLots: self.carparks, transpo: self.transport)
            return
        }
        let currentSchedules = self.schedules.filter { sched -> Bool in
            guard let startDate = sched.start else { return false }
            /// we make sure that the its within the desired date
           return Calendar.current.isDate(startDate, inSameDayAs: date)
        }
        self.processItems(scheds: currentSchedules, carLots: self.carparks, transpo: self.transport)
    }
}

extension InfoManager {
    /// Total section available
    func totalItems() -> Int {
        return items.count
    }
    
    /// Gives the total number of items per section
    ///
    /// - Parameter section: The  index of the item we want to count
    /// - Returns: Total item count for that section
    func numberOfItems(atSection section: Int) -> Int {
        guard items.count > section else { return 0 }
        let item = items[section]
        return item.itemCount
    }
    
    /// Gives the section details from the given index
    /// - Parameter section: The index of the item we want to look at
    /// - Returns: `TableSections` item
    func item(atSection section: Int) -> TableSections? {
        guard items.count > section else { return nil }
        return items[section]
    }
}
