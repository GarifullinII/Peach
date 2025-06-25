//
//  Extension + UIViewController.swift
//  Peach
//
//  Created by Василий on 05.09.2023.
//

import UIKit

extension UIViewController {
    /// Returns top presented controller
    var topPresentedViewController: UIViewController? {
        guard var topPresentedController = presentedViewController else { return nil }

        while let presentedController = topPresentedController.presentedViewController {
            topPresentedController = presentedController
        }

        return topPresentedController
    }

    func showAlert(type: AlertType) {
        let alertAction = UIAlertAction(title: AssetString.ok.rawValue, style: .cancel)
        let alertController = UIAlertController(title: type.title, message: nil, preferredStyle: .alert)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }

    func moveViewWithKeyboard(notification: NSNotification, block: @escaping ((Int) -> Void)) {
        guard let keyboardSize = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue else { return }

        let keyboardHeight = keyboardSize.height
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let keyboardCurve = UIView.AnimationCurve(
            rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!

        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            block(Int(keyboardHeight))
            self?.view.layoutIfNeeded()
        }

        animator.startAnimation()
    }

}
