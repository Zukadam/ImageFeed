import XCTest
import ImageFeed
import Foundation
@testable import ImageFeed

final class ProfileViewTest: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        //when
        _ = viewController.view
        //then
        XCTAssert(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateAvatar() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        //when
        presenter.loadData()
        //then
        XCTAssert(viewController.updateAvatarCalled)
    }
    
    func testPresenterCallsUpdateProfile() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        //when
        presenter.loadData()
        //then
        XCTAssert(viewController.updateProfileCalled)
    }
    
//    func testProfileViewControllerUpdateProfile() {
//        // given
//        let viewController = ProfileViewControllerStub()
//        let testProfile = Profile(
//            username: "testProfile",
//            name: "testProfile",
//            loginName: "testProfile",
//            firstName: "testProfile",
//            lastName: "testProfile",
//            bio: "testProfile"
//        )
//        //when
//        viewController.updateProfile(profile: testProfile)
//        //then
//        XCTAssertEqual(viewController.fullNameTextLabel.text, testProfile.name)
//        XCTAssertEqual(viewController.profileLoginTextLabel.text, testProfile.loginName)
//        XCTAssertEqual(viewController.profileStatusTextLabel.text, testProfile.bio)
//    }
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    func loadData() {
        <#code#>
    }
    
    func getProfileImage() {
        <#code#>
    }
    
    func logoutButtonWasTapped() {
        <#code#>
    }
    
    func logout() {
        <#code#>
    }
    
    
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var logoutDidCalled: Bool = false
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    func loadProfile(from profile: ImageFeed.Profile?) {
        
    }
    
    func loadAvatar(from url: URL?) {
        
    }
    func logoutDidTapped() {
        logoutDidCalled = true
    }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    func updateProfileDetails(profile: ImageFeed.Profile?) {
        <#code#>
    }
    
    func updateAvatar(url: URL) {
        <#code#>
    }
    
    func logoutButtonWasTapped() {
        <#code#>
    }
    
    
    var presenter: ProfileViewPresenterProtocol?
    
    var updateAvatarCalled: Bool = false
    
    var updateProfileCalled: Bool = false
    
    func updateProfile(profile: Profile?) {
        updateProfileCalled = true
    }
    
    func updateAvatar(from url: URL?) {
        updateAvatarCalled = true
    }
    
}
