import UIKit

final class ProfileService {
    // MARK: - Public Properties
    static let shared = ProfileService()
    
    // MARK: - Private Properties
    private(set) var profile: Profile?
    private let urlSession = URLSession.shared
    private let storage = OAuth2TokenStorage.shared
    private let builder = URLRequestBuilder.shared
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    private var lastToken: String?
    private var currentTask: URLSessionTask?
    
    // MARK: - Initialisers
    private init() {}
    
    // MARK: - Public Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        currentTask?.cancel()
        guard let request: URLRequest = makeProfileRequest(token: token ) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = fetch(for: request) { [weak self] response in
            self?.currentTask = nil // ???
//            guard let self else { return }
            DispatchQueue.main.async {
                switch response {
                case .success(let profileResult):
//                    do {
//                        let responseBody = try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
//                        print(responseBody)
//                        print(responseBody.accessToken)
//                        self.storage.token = responseBody.accessToken
//                        completion(.success(responseBody.accessToken))
//                    }  catch {
//                        completion(.failure(error))
//                    }
                    let profile = Profile(result: profileResult)
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
//                self.task = nil
//                self.lastToken = nil
            }
        }
//        self.task = task
        task.resume()
    }
    
    func fetch(for request: URLRequest, completion: @escaping (Result<ProfileResult, Error>) -> Void) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<ProfileResult, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
//                    fulfillCompletionOnTheMainThread(.success(data))
                    // start new code
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(ProfileResult.self, from: data)
                        fulfillCompletionOnTheMainThread(.success(result))
                        print(result)
                    } catch {
                        fulfillCompletionOnTheMainThread(.failure(NetworkError.decodingError(error)))
                    }
                    // end new code
                } else {
                    print("Status code not in correct range")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("Network error")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("Other problems in dataTask(with:completionHandler:)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
    
    func makeProfileRequest(token: String) -> URLRequest? {
//        guard let url = URL(string: Constants.unsplashGetProfileURLString) else {
//            print("Логирование ошибки")
//            return nil
//        }
//       
//        let token = String(describing: storage.token!)
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//        print("Request for makeProfileRequest method \(request)")
//        return request
        builder.makeHTTPRequest(path: "/me", httpMethod: "GET", baseURLString: Constants.defaultBaseURLString)
    }
}

//    На экране ProfileViewController в методе viewDidLoad нужно вызвать метод fetchProfile и обновить лейблы:
//    nameLabel (например, "Ivan Ivanov"),
//    loginNameLabel (например, "@ivanivanov"),
//    и descriptionLabel (совпадает с bio).
//    Добавьте вывод сообщений об ошибках в консоль.
