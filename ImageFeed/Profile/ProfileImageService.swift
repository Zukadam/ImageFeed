import Foundation

final class ProfileImageService {
    // MARK: - Public Properties
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    private var task: URLSessionTask?
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    private (set) var avatarURL: String?
    private var lastToken: String?
    private var currentTask: URLSessionTask?
    
    // MARK: - Initialisers
    private init() {}
    
    // MARK: - Public Methods
    func fetchProfileImageURL(with username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread, "Not in Main tread")
        task?.cancel()
        
        guard let request: URLRequest = makeProfileImageRequest(userName: username) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = fetch(for: request) { [weak self] response in
            guard let self else { return }
            DispatchQueue.main.async {
                switch response {
                case .success(let userResult):
                    guard let profileImageURL = userResult.profileImage.small else { preconditionFailure("can't get image URL") }
                    self.avatarURL = profileImageURL
                    completion(.success(profileImageURL))
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": profileImageURL]
                    )
                case .failure(let error):
                    print("Profile Image Service Error = \(error)")
                    completion(.failure(error))
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    func fetch(for request: URLRequest, completion: @escaping (Result<UserResult, Error>) -> Void) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<UserResult, Error>) -> Void = {
            result in DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = urlSession.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(UserResult.self, from: data)
                        fulfillCompletionOnTheMainThread(.success(result))
                        print(result)
                    } catch {
                        fulfillCompletionOnTheMainThread(.failure(NetworkError.decodingError(error)))
                    }
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
    
    func makeProfileImageRequest(userName: String) -> URLRequest? {
        builder.makeHTTPRequest(path: "/users/\(userName)", httpMethod: "GET", baseURLString: Constants.defaultBaseAPIURLString)
    }
}
