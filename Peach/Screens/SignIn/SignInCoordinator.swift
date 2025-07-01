//
//  SignInCoordinator.swift
//  Peach
//
//  Created by Василий on 14.09.2023.
//

import UIKit
import Combine

final class SignInCoordinator: BaseCoordinator {
    
    // MARK: - Nested types
    
    enum Output {
        case dismiss
    }
    
    // MARK: - Properties
    
    var output = PassthroughSubject<Output, Never>()
    
    private let router: Router
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializers
    
    init(router: Router) {
        self.router = router
    }
    
    deinit {
        print("❌Deinit:", String(describing: self))
    }
    
    // MARK: - Instance methods
    
    override func start() {
        showSignIn()
    }
    
    private func showSignIn() {
        let viewModel = SignInViewModelImpl()
        let view = SignInView(viewModel: viewModel)
        let vc = SignInViewController(contentView: view)
        
        viewModel.output.sink { [weak self] output in
            guard let self else { return }
            
            switch output {
            case .showAlert:
                self.showAlertController()
            case .showInvalidAgeAlert:
                self.showInvalidAgeAlertController()
            case .showAgeAlert(let title, let message):
                self.showAgeAlertController(title: title, message: message)
            case .dismiss:
                self.output.send(.dismiss)
            }
        }.store(in: &cancellables)
        
        router.setRootModule(vc)
    }
    
    func showAlertController() {
        let alertController = UIAlertController(
            title: AssetString.fill_all_fields.text, message: nil, preferredStyle: .alert
        )
        let alertAction = UIAlertAction(title: AssetString.ok.text, style: .cancel)
        alertController.addAction(alertAction)
        router.present(alertController)
    }
    
    private func showInvalidAgeAlertController() {
        let alertController = UIAlertController(
            title: AssetString.warning.text,
            message: AssetString.invalid_age.text,
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(title: AssetString.ok.text, style: .default)
        alertController.addAction(alertAction)
        router.present(alertController)
    }
    
    private func showAgeAlertController(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(title: AssetString.ok.text, style: .default)
        alertController.addAction(alertAction)
        router.present(alertController)
    }
}
