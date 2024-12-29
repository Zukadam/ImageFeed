import Foundation

struct Profile {
    // MARK: - Public Properties
    let username: String
    let name: String
    let loginName: String
    let bio: String?
//    username — логин пользователя в том же виде, в каком мы получаем его от сервиса,
//    name — конкатенация имени и фамилии пользователя (если first_name = "Ivan", last_name = "Ivanov", то name = "Ivan Ivanov"),
//    loginName — username со знаком @ перед первым символом (если username = "ivanivanov", то loginName = "@ivanivanov"),
//    bio совпадает с bio из ProfileResult.
}

// MARK: - Initialiser Extension
extension Profile {
    init(result profile: ProfileResult) {
        self.init(
            username: profile.userLogin,
            name: "\(profile.firstName ?? "") \(profile.lastName ?? "")",
            loginName: "@\(profile.userLogin)",
            bio: profile.bio
        )
    }
}
