import Foundation

struct ProfileResult: Codable {
    // MARK: - Public Properties
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?
}
