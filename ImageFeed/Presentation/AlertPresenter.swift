import UIKit

protocol AlertPresenterProtocol {
    static func showAlert(model: AlertModel, vc: UIViewController)
}

class AlertPresenter: AlertPresenterProtocol {
    // MARK: - Initialisers
    private init() { }
    // MARK: - Public Methods
    static func showAlert(model: AlertModel, vc: UIViewController) {
        let alertController = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alertController.addAction(alertAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
}

//class AlertPresenter: AlertPresenterProtocol {
//    weak var delegate: UIViewController?
//    
//    func showAlert(title: String, message: String, handler: @escaping () -> Void) {
//        let alert = UIAlertController(
//            title: title,
//            message: message,
//            preferredStyle: .alert
//        )
//        
//        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
//            handler()
//        }
//        alert.addAction(alertAction)
//        delegate?.present(alert, animated: true)
//    }
//}
