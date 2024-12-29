import Foundation

struct ProfileResult: Codable {
    // MARK: - Public Properties
    let userLogin: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?
    
//    private enum CodingKeys: String, CodingKeys {
//        case userLogin = "username"
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case bio
//        case profileImage = "profile_image"
//    }
    
//    Добавьте структуру struct ProfileResult: Codable для декодирования ответа. Какие поля добавить, вам нужно понять самостоятельно, анализируя документацию. Если нужно освежить знания об этом, вернитесь в урок «Протокол Codable» темы «Хранение данных».
    
//Примечание: проверьте самостоятельно какие из полей могут не приходить от сервиса Unsplash, иными словами – будут опциональными. Попробуйте отправить запрос и посмотрите, что сервис возвращает, сравните с документацией. Также попробуйте отредактировать свой профиль напрямую на Unsplash с пустыми полями.
}
