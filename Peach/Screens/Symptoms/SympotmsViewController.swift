//
//  SympotmsViewController.swift
//  Peach
//
//  Created by Василий on 22.09.2023.
//

import UIKit
import Combine

final class SympotmsViewController<View: SymptomsView>:
    BaseViewController<View>, UICollectionViewDataSource,
    UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
        
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscibeDelegates()
        contentViewActions()
        subscribeNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        contentView.viewModel.input.send(.dismiss)
    }
    
    deinit {
        print("❌Deinit:", String(describing: self))
    }
    
    // MARK: - Instance methods
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        //      self.view.frame.origin.y = 0 - keyboardSize.height
        
        // Проверяем валидность высоты клавиатуры
        let keyboardHeight = keyboardSize.height
        guard keyboardHeight.isFinite && !keyboardHeight.isNaN && keyboardHeight > 0 else {
            print("⚠️ Warning: Invalid keyboard height: \(keyboardHeight)")
            return
        }
        
        self.view.frame.origin.y = 0 - keyboardHeight
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    private func subscibeDelegates() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
    }
    
    private func contentViewActions() {
        contentView.saveHandler = { [weak self] in
            if let symptom = self?.contentView.textField.text {
                self?.contentView.viewModel.input.send(.addAdditionalSymptom(symptom))
            }
            self?.contentView.viewModel.input.send(.save)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        contentView.endEditing(true)
    }
    
    private func subscribeNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    // MARK: - UICollectionViewDataSource methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return contentView.viewModel.dataSource.value?.symptoms.count ?? 0
        case 1:
            return contentView.viewModel.dataSource.value?.discharge.count ?? 0
        case 2:
            return contentView.viewModel.dataSource.value?.profuseBleeding.count ?? 0
        case 3:
            return contentView.viewModel.dataSource.value?.mySymptoms.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(
            withType: SymptomCell.self,
            for: indexPath
        )
        
        cell.isChoosen = contentView.viewModel.selectedSymptoms[indexPath] ?? false
        
        switch indexPath.section {
        case 0:
            cell.configure(
                type: (contentView.viewModel.dataSource.value?.symptoms[indexPath.row])!
            )
            return cell
        case 1:
            cell.configure(
                type: (contentView.viewModel.dataSource.value?.discharge[indexPath.row])!
            )
            return cell
        case 2:
            cell.configure(
                type: (contentView.viewModel.dataSource.value?.profuseBleeding[indexPath.row])!
            )
            return cell
        case 3:
            cell.configure(
                type: (contentView.viewModel.dataSource.value?.mySymptoms[indexPath.row])!
            )
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    // MARK: - UICollectionViewDelegate methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SymptomCell
        cell.toggle()
        contentView.viewModel.input.send(.refreshModel(indexPath))
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableView(
            for: indexPath,
            viewType: HeaderView.self,
            kind: .header)
        headerView.configure(
            text: contentView.viewModel.headerDataSource.value[indexPath.section]
        )
        return headerView
    }
}

extension SympotmsViewController {
    
    // MARK: - Instance methods
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let backButton = UIBarButtonItem(
            image: AssetImage.backArrow.image,
            style: .plain,
            target: navigationController,
            action: #selector(UINavigationController.popViewController(animated:))
        )
        backButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}
