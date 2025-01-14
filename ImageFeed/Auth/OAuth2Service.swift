import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    // MARK: - Public Properties
    static let shared = OAuth2Service()
    
    // MARK: - Private Properties
    private let storage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    private var task: URLSessionTask?
    private var lastCode: String?
    
    // MARK: - Initialisers
    private init() {}
    
    // MARK: - Public Methods
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread, "Not in Main tread")
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code
        
        guard let request: URLRequest = makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.data(for: request) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let responseBody = try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
                        print(responseBody)
                        print(responseBody.accessToken)
                        self.storage.token = responseBody.accessToken
                        completion(.success(responseBody.accessToken))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
                self.task = nil
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
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
        
        guard let url = urlComponents.url?.absoluteString else {
            print("Логирование ошибки")
            assertionFailure("Failed to create URL")
            return nil
        }
        
        let request = builder.makeHTTPRequest(path: url, httpMethod: "POST", baseURLString: Constants.defaultBaseURLString)
        
        print("Request for makeOAuthTokenRequest method \(String(describing: request))")
        return request
    }
}
