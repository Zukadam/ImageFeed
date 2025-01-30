import UIKit

public protocol ProfileViewPresenterProtocol {
    // MARK: - Public Properties
    var view: ProfileViewControllerProtocol? { get set }
    // MARK: - Public Methods
    func loadData()
    func getProfileImage()
    func logoutButtonWasTapped()
    func logout()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    // MARK: - Public Properties
    weak var view: ProfileViewControllerProtocol?
    
    // MARK: - Private Properties
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?

    
    // MARK: - Public Methods
    func loadData() {
        addProfileImageObserver()
        
        loadProfile(profile: profileService.profile)
        loadAvatar(url: profileImageService.avatarURL ?? URL(string: Constants.defaultAvatarURLString)!)
    }
    
    func logoutButtonWasTapped() {
        view?.logoutButtonWasTapped()
    }
    
    func logout() {
        profileLogoutService.logout()
        switchToSplashViewController()
    }
 
    func getProfileImage() {
        guard let profile = profileService.profile else { return }
        profileImageService.fetchProfileImageURL(with: profile.username) { _ in }
    }
}

// MARK: - private extension
extension ProfileViewPresenter {
    private func addProfileImageObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: Constants.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] notification in
                guard let self else { return }
                guard
                    let profileImageURL = notification.userInfoImageURL,
                    let url = URL(string: profileImageURL)
                else { return }
                view?.updateAvatar(url: url)
            }
    }
    
    private func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else {
            print("Error in \(#function): Invalid Configuration")
            return
        }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
    
    private func loadAvatar(url: URL) {
        view?.updateAvatar(url: url)
    }
    
    private func loadProfile(profile: Profile?) {
        view?.updateProfileDetails(profile: profile)
    }
}
