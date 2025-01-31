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
