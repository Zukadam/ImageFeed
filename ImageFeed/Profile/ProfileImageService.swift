import Foundation

final class ProfileImageService {
    // MARK: - Public Properties
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
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
        
        let task = urlSession.objectTask(for: request) {
            [weak self] (response: Result<UserResult, Error>) in
            guard let self else { return }
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
        self.task = task
        task.resume()
    }
    
    func makeProfileImageRequest(userName: String) -> URLRequest? {
        builder.makeHTTPRequest(path: "/users/\(userName)", httpMethod: "GET", baseURLString: Constants.defaultBaseAPIURLString)
    }
}
