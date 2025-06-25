//
//  BaseViewController.swift
//  Peach
//
//  Created by Василий on 07.09.2023.
//

import UIKit
import Combine

class BaseViewController<View: UIView>: UIViewController {

    // MARK: - Instance Properties

    let contentView: View
    var cancellableSet = Set<AnyCancellable>()

    // MARK: - Initializers

    init(contentView: View) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController Methods

    override func loadView() {
        self.view = self.contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind().forEach { cancellable in
            cancellableSet.insert(cancellable)
        }
    }

    // MARK: - Instance Methods

    func setUp() {
        view.backgroundColor = .white
    }

    func bind() -> [AnyCancellable] {
        []
    }
}
