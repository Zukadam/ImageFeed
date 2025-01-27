import Foundation
import WebKit
import SwiftKeychainWrapper

final class ProfileLogoutService {
    // MARK: - Public Properties
    static let shared = ProfileLogoutService()

    // MARK: - Private Properties

    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let ImageListService = ImagesListService.shared
    
    // MARK: - Initialisers
    private init() {}
    
    // MARK: - Public Methods
    func logout() {
        cleanCookies()
        cleanToken()
        clearProfileImage()
        clearImageListImages()
    }
    
    // MARK: - Private Methods
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanToken() {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "Auth token")
        guard removeSuccessful else {
            print("Error in \(#function): token not removed")
            return
        }
    }
    
    private func clearProfileImage() {
        profileImageService.clearAvatarURL()
    }
    
    private func clearImageListImages() {
        ImageListService.clearPhotos()
    }
}

