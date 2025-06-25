//
//  PremiumSheetViewController.swift
//  Peach
//
//  Created by Василий on 21.09.2023.
//

import UIKit
import BottomSheet

final class PremiumSheetViewController<View: PremiumViewInput>:
    UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties

    private let contentView: View

    private let scrollView = UIScrollView().then {
        $0.isScrollEnabled = false
    }
    
    // MARK: - Private properties

    private var currentHeight: CGFloat {
        didSet {
            updatePreferredContentSize()
        }
    }

    // MARK: - Initializers

    init(contentView: View, currentHeight: CGFloat, type: SheetType) {
        self.contentView = contentView
        self.currentHeight = currentHeight

        self.contentView.configure(type: type)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()

        setupSubview()
        updatePreferredContentSize()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
        contentViewActions()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        contentView.viewModel.input.send(.dismiss)
    }

    deinit {
        print("❌Deinit:", String(describing: self))
    }

    // MARK: - Instance methods

    private func contentViewActions() {
        contentView.paymentButtonHandler = { [weak self] in
            self?.contentView.viewModel.input.send(.paymentTap)
        }
        contentView.closeTapHandler = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    private func subscribeDelegate() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }

    private func setupSubview() {
        view.backgroundColor = .white

        view.add {
            scrollView
        }

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.add {
            contentView
        }

        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
    }

    private func updatePreferredContentSize() {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: currentHeight)
        preferredContentSize = scrollView.contentSize
    }

    // MARK: - UITableViewDataSource methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return contentView.viewModel.paymentCellModel.value.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: PaymentCell.self, for: indexPath)
        cell.configure(model: contentView.viewModel.paymentCellModel.value[indexPath.section])
        contentView.viewModel.cells.value.append(cell)
        return cell
    }

    // MARK: - UITableViewDelegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.viewModel.cells.value.forEach {
            if $0.paymentIsSelected == false {
                $0.paymentIsSelected = true
                contentView.viewModel.paymentID.value = $0.id
            } else {
                $0.paymentIsSelected = false
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
