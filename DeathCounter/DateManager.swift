//
//  DateManager.swift
//  DeathCounter
//
//  Created by Andrei Konstantinov on 06/01/2020.
//  Copyright © 2020 8of. All rights reserved.
//

import Cocoa

final class DateManager: NSObject {

    var daysLeft: Int {
        return Calendar
            .current
            .dateComponents([.day], from: Date(), to: endDate())
            .day
            ?? 0
    }

    var yearsLeft: Int {
        return Calendar
            .current
            .dateComponents([.year], from: Date(), to: endDate())
            .year
            ?? 0
    }

}

// MARK: - Private

private extension DateManager {

    func endDate() -> Date {
        var components = DateComponents()
        components.year = 2057
        components.month = 9
        components.day = 16

        return Calendar
            .current
            .date(from: components)
            ?? Date()
    }

}
