import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    // MARK: - Initializers
    private init() { }
    // MARK: - Public Methods
    static func showAlert(model: AlertModel, vc: UIViewController) {
        let alertController = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let alertFirstAction = UIAlertAction(title: model.firstButtonText, style: .default) { _ in
            model.completion()
        }
        alertController.addAction(alertFirstAction)
        
        if model.secondButtonText != nil {
            let alertSecondAction = UIAlertAction(title: model.secondButtonText, style: .default) { _ in
                vc.dismiss(animated: true)
            }
            alertController.addAction(alertSecondAction)
        }
        
        vc.present(alertController, animated: true, completion: nil)
    }
}
