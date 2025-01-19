import UIKit

final class SplashViewController: UIViewController {
    // MARK: - Private Properties
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let storage = OAuth2TokenStorage.shared
//    private let alertPresenter = AlertPresenter()
    private var authenticateStatus = false
        
    // MARK: - Overrides Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
//        checkAuthStatus()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isAuthenticated()
    }
    
    // MARK: - Private Methods
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: Constants.tabBarViewController)
        window.rootViewController = tabBarController
//        guard let window = UIApplication.shared.windows.first else {
//            assertionFailure("Invalid Configuration")
//            return
//        }
//        let tabBarController = TabBarController()
//        window.rootViewController = tabBarController
    }
    
    private func showAuthController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(identifier: "AuthViewControllerID")
        guard let authViewController = viewController as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func isAuthenticated() {
        guard !authenticateStatus else { return }
        
        authenticateStatus = true
        
        if storage.token != nil {
            UIBlockingProgressHUD.show()
            fetchProfile { [weak self] in
                guard let self else { return }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            }
            
        } else {
//            let authViewController = AuthViewController()
//            authViewController.delegate = self
//            authViewController.modalPresentationStyle = .fullScreen
//            present(authViewController, animated: true)
            showAuthController()
        }
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
            case .success:
//                self.switchToTabBarController()
//                fetchProfile(token)
                self.fetchProfile { UIBlockingProgressHUD.dismiss() }
            case .failure(let error):
                print("Fetch token error in \(#function): error = \(error)")
                self.showLoginAlert()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func fetchProfile(completion: @escaping () -> Void ) {
//        UIBlockingProgressHUD.show()
        guard let token = storage.token else { return }
        profileService.fetchProfile(token) { [weak self] result in
//            UIBlockingProgressHUD.dismiss()
            guard let self else { return }

            switch result {
            case .success(let profile):
                self.switchToTabBarController()
                let username = profile.username
                self.fetchProfileImageURL(username: username)
            case .failure(let error):
                print("Fetch token error in \(#function): error = \(error)")
                self.showLoginAlert()
            }
//            UIBlockingProgressHUD.dismiss()
            completion()
        }
    }
    
    private func fetchProfileImageURL(username: String) {
        profileImageService.fetchProfileImageURL(with: username) { result in
            switch result {
            case .success(let imageURL):
                print("imageURL - \(imageURL)")
            case .failure(let error):
                print("Fetch image error in \(#function): error = \(error)")
                self.showLoginAlert()
            }
        }
    }
    
    private func showLoginAlert() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { preconditionFailure("weak self error")}
            let alertModel = AlertModel(
                title: "Что-то пошло не так(",
                message: "Не удалось войти в систему",
                buttonText: "Ок"
            ) { [weak self] in
                guard let self else { preconditionFailure("weak self error")}
                self.authenticateStatus = false
                self.isAuthenticated()
            }
            AlertPresenter.showAlert(model: alertModel, vc: self)
        }
    }
    
    //Not mine
    private func presentAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
//        storyboard.instantiateInitialViewController()
        let viewController = storyboard.instantiateViewController(identifier: "AuthViewControllerID")
        guard let authViewController = viewController as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }

//    private func showAlert() {
//        DispatchQueue.main.async { [weak self] in
//            guard let self else { preconditionFailure("weak self error")}
//            let alertModel = AlertModel(
//                title: "Что-то пошло не так(",
//                message: "Не удалось войти в систему",
//                buttonText: "Ок"
//            ) { [weak self] in
//                guard let self else { preconditionFailure("weak self error")}
//                self.authenticateStatus = false
//                self.isAuthenticated()
//            }
//            AlertPresenter.showAlert(model: alertModel, vc: self)
//        }
//    }
}


