import Foundation

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateProfileDetails(profile: Profile?)
    func updateAvatar(url: URL)
    func logoutButtonWasTapped()
}
