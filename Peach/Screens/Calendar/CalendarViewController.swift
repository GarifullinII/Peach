//
//  CalendarViewController.swift
//  Peach
//
//  Created by Василий on 05.09.2023.
//

import HorizonCalendar
import UIKit

final class CalendarViewController: BaseViewController<CalendarVieW> {

    // MARK: - Properties


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        contentViewActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    deinit {
        print("❌Deinit:", String(describing: self))
    }

    // MARK: - Instance methods

    private func contentViewActions() {
//        contentView.singleDaySelectionHandler = { day in
//            print(day)
//        }
    }
}
