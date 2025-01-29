import UIKit

final class ProfileService {
    // MARK: - Public Properties
    static let shared = ProfileService()
    
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    private(set) var profile: Profile?
    private var lastToken: String?
    private var currentTask: URLSessionTask?
    
    // MARK: - Initialisers
    private init() {}
    
    // MARK: - Public Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread, "Not in Main tread")
        if currentTask != nil {
            if lastToken != token {
                currentTask?.cancel()
            } else {
                if lastToken == token {
                    completion(.failure(NetworkError.raceError))
                }
            }
            lastToken = token
        }
        
        guard let request: URLRequest = makeProfileRequest() else {
            completion(.failure(NetworkError.urlRequestError))
            return
        }
        
        let task = urlSession.objectTask(for: request) {
            [weak self] (response: Result<ProfileResult, Error>) in
            guard let self else { return }
            switch response {
            case .success(let profileResult):
                let profile = Profile(result: profileResult)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("Profile Service Error in \(#function): error = \(error)")
                completion(.failure(error))
            }
            self.currentTask = nil
            self.lastToken = nil
        }
        self.currentTask = task
        task.resume()
    }
    
    // MARK: - Private Methods
    private func makeProfileRequest() -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURLString: Constants.defaultBaseAPIURLString
        )
    }
}
