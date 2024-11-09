import Foundation

final class OAuth2Service {
    // MARK: - Public Properties
    var authToken: String? {
        get {
            storage.token
        }
        set {
            storage.token = newValue
        }
    }
    
    static let shared = OAuth2Service()
    
    // MARK: - Private Properties
    private let storage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    // MARK: - Initialisers
    private init() {}
    
    // MARK: - Public Methods
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let request: URLRequest = makeOAuthTokenRequest(code: code)
        
        let task = urlSession.data(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    print(responseBody)
                    print(responseBody.accessToken)
                    self.authToken = responseBody.accessToken
                    completion(.success(responseBody.accessToken))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
        
    func makeOAuthTokenRequest(code: String) -> URLRequest {
        guard var urlComponents = URLComponents(string: Constants.unsplashGetTokenURLString) else {
            preconditionFailure("Invalid token")
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: Constants.grantType)
        ]
        guard let url = urlComponents.url else {
            preconditionFailure("Error OAuth urlComponents.url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        print("Request for makeOAuthTokenRequest method \(request)")
        
        return request
    }
}
