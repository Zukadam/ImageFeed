import UIKit
//import ProgressHUD

final class SplashViewController: UIViewController {
    // MARK: - Private Properties
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let storage = OAuth2TokenStorage.shared
    
    // MARK: - Overrides Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = storage.token {
            switchToTabBarController()
            fetchProfile(token)
        } else {
            performSegue(withIdentifier: Constants.showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    // MARK: - Private Methods
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: Constants.tabBarViewController)
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.showAuthenticationScreenSegueIdentifier, sender: nil)
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
                    
            else {
                fatalError("Failed to prepare for \(Constants.showAuthenticationScreenSegueIdentifier)")
            }
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.fetchOAuthToken(code)
        }
        
    }
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let token):
                self.switchToTabBarController()
                fetchProfile(token)
            case .failure:
                // TODO [Sprint 11]
                break
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self = self else { return }

            switch result {
            case .success:
//               self.switchToTabBarController()
                print(result)

            case .failure:
                // TODO [Sprint 11] Покажите ошибку получения профиля
                break
            }
        }
    }
    
    private func fetchProfileImageURL(username: String) {
        profileImageService.fetchProfileImageURL(with: username) { result in
            switch result {
            case .success(let imageURL):
                print("imageURL - \(imageURL)")
            case .failure(let error):
                print("fetch image error \(error)")
            }
        }
    }
    
}
