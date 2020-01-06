//
//  StatusMenuController.swift
//  DeathCounter
//
//  Created by Andrei Konstantinov on 06/01/2020.
//  Copyright © 2020 8of. All rights reserved.
//

import Cocoa

final class StatusMenuController: NSObject {

    @IBOutlet private weak var statusMenu: NSMenu!
    @IBOutlet private weak var dateMenuItem: NSMenuItem!

    private let dateManager = DateManager()
    private var isYearsMode = false
    private var timer: Timer?

    private let statusItem: NSStatusItem = {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        let image = NSImage(named: "statusIcon")
        image?.isTemplate = true
        item.button?.image = image

        return item
    }()

    deinit {
        NotificationCenter
            .default
            .removeObserver(self)
        timer?.invalidate()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        statusItem.menu = statusMenu
        setData()

        // When user manually changes time / date
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(setData),
                name: NSNotification.Name.NSSystemClockDidChange,
                object:nil
        )

        // When time goes forward naturally
        timer?.invalidate()
        timer = Timer
            .scheduledTimer(timeInterval: 12 * 60 * 60, // 12 hours
                            target: self,
                            selector: #selector(setData),
                            userInfo: nil,
                            repeats: true
        )
        timer?.tolerance = 60 * 60 // 1 hour
    }

}

// MARK: - Private

private extension StatusMenuController {

    @objc func setData() {
        let word = isYearsMode ? "Years" : "Days"
        let count = isYearsMode ? dateManager.yearsLeft : dateManager.daysLeft
        dateMenuItem.title = "\(word) left: \(count)"
    }

    func switchMode() {
        isYearsMode = !isYearsMode
        setData()
    }

}

// MARK: - Actions

private extension StatusMenuController {

    @IBAction func dateTapped(_ sender: Any) {
        switchMode()
    }

    @IBAction func quitTapped(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }

}
