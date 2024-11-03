import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Private Properties
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oAuth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage()

    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController 
            else {
                fatalError("Failed to prepare for \(showWebViewSegueIdentifier)")
            }
                webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_web_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_web_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black (iOS)")
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    // MARK: - Public Methods
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //TODO: process code

        delegate?.authViewController(self, didAuthenticateWithCode: code)
//        vc.dismiss(animated: true)

        navigationController?.popToRootViewController(animated: true)

    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
//        vc.dismiss(animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
}
