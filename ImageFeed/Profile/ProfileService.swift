import UIKit

final class ProfileService {
    // MARK: - Public Properties
    static let shared = ProfileService()
    
    // MARK: - Private Properties
    private(set) var profile: Profile?
    
    // MARK: - Initialisers
    private init() {}
    
    // MARK: - Public Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
//        assert(Thread.isMainThread, "Not in Main tread")
        guard let request: URLRequest = makeProfileRequest(token: token ) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            DispatchQueue.main.async {
                if let error {
                    completion(.failure(error))
                    return
                }
                guard let data else {
                    completion(.failure(AuthServiceError.invalidRequest))
                    return
                }
                do {
                    let responseBody = try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
                    print(responseBody)
                    print(responseBody.accessToken)
                    self.storage.token = responseBody.accessToken
                    completion(.success(responseBody.accessToken))
                } catch {
                    completion(.failure(error))
                }
        }
        task.resume()
    }
    
    func makeProfileRequest(token: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.unsplashGetTokenURLString) else {
            print("Логирование ошибки")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: Constants.grantType)
        ]
        
        guard let url = urlComponents.url else {
            print("Логирование ошибки")
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        print("Request for makeProfileRequest method \(request)")
        
        return request
    }
    
//    Метод fetchProfile не должен приводить к гонкам, если он вызывается несколько раз подряд (каждый следующий вызов не дожидается завершения         предыдущего).
//    На экране ProfileViewController в методе viewDidLoad нужно вызвать метод fetchProfile и обновить лейблы:
//    nameLabel (например, "Ivan Ivanov"),
//    loginNameLabel (например, "@ivanivanov"),
//    и descriptionLabel (совпадает с bio).
//    Добавьте вывод сообщений об ошибках в консоль.
    
}

