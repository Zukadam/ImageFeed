import Foundation

struct ProfileResult: Codable {
    // MARK: - Public Properties
    let userLogin: String
//    let id: String
    let firstName: String?
    let lastName: String?
    let bio: String?
//    let profileImage: ProfileImage?
    
    private enum CodingKeys: String, CodingKey {
        case userLogin = "username"
//        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
//        case profileImage = "profile_image"
    }
    
//    Добавьте структуру struct ProfileResult: Codable для декодирования ответа. Какие поля добавить, вам нужно понять самостоятельно, анализируя документацию. Если нужно освежить знания об этом, вернитесь в урок «Протокол Codable» темы «Хранение данных».
    
//Примечание: проверьте самостоятельно какие из полей могут не приходить от сервиса Unsplash, иными словами – будут опциональными. Попробуйте отправить запрос и посмотрите, что сервис возвращает, сравните с документацией. Также попробуйте отредактировать свой профиль напрямую на Unsplash с пустыми полями.
}

//{
//  "id": "pXhwzz1JtQU",
//  "updated_at": "2016-07-10T11:00:01-05:00",
//  "username": "jimmyexample",
//  "first_name": "James",
//  "last_name": "Example",
//  "twitter_username": "jimmy",
//  "portfolio_url": null,
//  "bio": "The user's bio",
//  "location": "Montreal, Qc",
//  "total_likes": 20,
//  "total_photos": 10,
//  "total_collections": 5,
//  "followed_by_user": false,
//  "downloads": 4321,
//  "uploads_remaining": 4,
//  "instagram_username": "james-example",
//  "location": null,
//  "email": "jim@example.com",
//  "links": {
//    "self": "https://api.unsplash.com/users/jimmyexample",
//    "html": "https://unsplash.com/jimmyexample",
//    "photos": "https://api.unsplash.com/users/jimmyexample/photos",
//    "likes": "https://api.unsplash.com/users/jimmyexample/likes",
//    "portfolio": "https://api.unsplash.com/users/jimmyexample/portfolio"
//  }
//}
