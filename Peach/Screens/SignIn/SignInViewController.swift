//
//  SignInViewController.swift
//  Peach
//
//  Created by Василий on 14.09.2023.
//

import UIKit
import Combine
import SnapKit

final class SignInViewController
<View: SignInView>: BaseViewController<View>, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    private lazy var topTextFieldHandler = { [weak self] (text: String, index: Int) in
        guard let self else { return }
        
        self.contentView.viewModel.input.send(.fillFromTopTF(text, index))
    }
    
    private lazy var bottomTextFieldHandler = { [weak self] (text: String) in
        guard let self else { return }
        
        self.contentView.viewModel.input.send(.fillFromBottomTF(text))
    }
    
    private lazy var dateHandler = { [weak self] (date: Date, index: Int) in
        guard let self else { return }
        
        self.contentView.viewModel.input.send(.setDate(date, index))
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeDelegates()
        contentViewActions()
        subscribeNotifications()
    }
    
    deinit {
        print("❌Deinit:", String(describing: self))
    }
    
    // MARK: - Instance methods
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification) { [weak self] keyboardHeight in
            self?.contentView.updateConstraint(height: CGFloat(keyboardHeight))
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification) { [weak self] keyboardHeight in
            guard let self else { return }
            
            self.contentView.updateConstraint(height: self.contentView.viewModel.buttonConstraintSize)
        }
    }
    
    private func subscribeDelegates() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
    }
    
    private func subscribeNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func contentViewActions() {
        contentView.continueHandler = { [weak self] in
            guard let self else { return }
            
            let index: IndexPath = [0, self.contentView.viewModel.nextIndex]
            
            if index.item != self.contentView.viewModel.signInModel.value.count {
                if contentView.viewModel.checkFilling() {
                    self.contentView.collectionView.scrollToItem(at: index, at: .right, animated: true)
                }
            } else {
                if self.contentView.viewModel.userModel.value?.isFilled == true {
                    self.contentView.viewModel.input.send(.saveModel)
                } else {
                    contentView.viewModel.input.send(.showAlert)
                }
            }
        }
        
        contentView.viewModel.output.sink { [weak self] output in
            switch output {
            case .showAgeAlert(let title, let message):
                self?.showAgeAlert(title: title, message: message)
            case .showInvalidAgeAlert:
                self?.showInvalidAgeAlert()
            case .showAlert:
                self?.showAlert()
            case .dismiss:
                self?.dismiss(animated: true)
            }
            
        }.store(in: &cancellableSet)
    }
    
    private func showAgeAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: AssetString.ok.text, style: .default))
        present(alert, animated: true)
    }
    
    private func showInvalidAgeAlert() {
        let alert = UIAlertController(
            title: AssetString.warning.text,
            message: AssetString.invalid_age.text,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: AssetString.ok.text, style: .default))
        present(alert, animated: true)
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: AssetString.fill_all_fields.text,
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: AssetString.ok.text,
            style: .default
        ))
        present(alert, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource methods
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return contentView.viewModel.signInModel.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withType: SignInCell.self, for: indexPath)
        cell.configure(
            model: contentView.viewModel.signInModel.value[indexPath.item],
            index: indexPath.item
        )
        cell.topTextFieldHandler = topTextFieldHandler
        cell.bottomTextFieldHandler = bottomTextFieldHandler
        cell.dateHandler = dateHandler
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        //        return CGSize(width: contentView.frame.width, height: 300)
        
        let width = contentView.frame.width
        
        // Проверяем валидность ширины contentView
        guard width.isFinite && !width.isNaN && width > 0 else {
            print("⚠️ Warning: Invalid contentView frame width in SignInViewController: \(width)")
            return CGSize(width: 375, height: 300) // Безопасная ширина по умолчанию
        }
        
        return CGSize(width: width, height: 300)
    }
}
