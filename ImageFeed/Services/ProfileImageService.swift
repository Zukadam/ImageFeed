import Foundation

final class ProfileImageService {
    // MARK: - Public Properties
    static let shared = ProfileImageService()
    
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    private (set) var avatarURL: URL?
    private var task: URLSessionTask?
    private var currentTask: URLSessionTask?
    
    // MARK: - Initialisers
    private init() {}
    
    // MARK: - Public Methods
    func clearAvatarURL() {
        avatarURL = nil
    }
    
    func fetchProfileImageURL(with username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread, "Not in Main tread")
        task?.cancel()
        
        guard let request: URLRequest = makeProfileImageRequest(userName: username) else {
            completion(.failure(NetworkError.urlRequestError))
            return
        }
        
        let task = urlSession.objectTask(for: request) {
            [weak self] (response: Result<UserResult, Error>) in
            guard let self else { return }
            switch response {
            case .success(let userResult):
                guard let profileImageURL = userResult.profileImage.large else { preconditionFailure("can't get image URL") }
                self.avatarURL = URL(string: profileImageURL)
                completion(.success(profileImageURL))
                NotificationCenter.default
                    .post(
                        name: Constants.didChangeNotification,
                        object: self,
                        userInfo: [Notification.userInfoImageURLKey: profileImageURL]
                    )
            case .failure(let error):
                print("Profile Image Service Error in \(#function): error = \(error)")
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    private func makeProfileImageRequest(userName: String) -> URLRequest? {
        builder.makeHTTPRequest(path: "/users/\(userName)", httpMethod: "GET", baseURLString: Constants.defaultBaseAPIURLString)
    }
}
