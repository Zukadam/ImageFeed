import Foundation

final class OAuth2Service {
    // MARK: - Public Properties
    var authToken: String? {
        get {
            OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    static let shared = OAuth2Service()
    
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()
    
    private enum NetworkError: Error {
        case codeError
    }
    
    // MARK: - Initialisers
    private init() {}
    
    // MARK: - Public Methods
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let request: URLRequest = makeOAuthTokenRequest(code: code)
        
        let task = urlSession.data(for: request) { [weak self] result in
            guard let self else { preconditionFailure("Fail in fetchOAuthToken(), not found self") }
            
            switch result {
            case .success(let data):
                do {
                    let OAuthTokenResponseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    print(OAuthTokenResponseBody)
                    print(OAuthTokenResponseBody.accessToken)
                    self.authToken = OAuthTokenResponseBody.accessToken
                    completion(.success(OAuthTokenResponseBody.accessToken))
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
            URLQueryItem(name: "grant_type", value: Constants.grant_type)
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
