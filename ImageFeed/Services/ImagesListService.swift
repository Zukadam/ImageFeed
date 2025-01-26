import Foundation

struct ImageURLResponse: Decodable {
    let regular: URL
}

struct ImageListResponse: Decodable {
    let urls: ImageURLResponse
}

struct ImageResponse: Decodable {
    let url: URL
}

enum ImagesListServiceError: Error {
    case urlRequestCreationFailed
    case invalidData
    case taskExist
}

final class ImagesListService {
    private init() {}
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let storageService = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    private var dataTask: URLSessionTask?
    private (set) var photos: [Photo] = []
    private var pageCount: Int?
    
    // MARK: - Public Methods
    func fetchPhotosNextPage(completion: @escaping (Result<[PhotoResult], Error>) -> Void) {
        
        assert(Thread.isMainThread)
        
        guard let request = makePhotosRequest() else {
            print(NetworkError.urlRequestError)
            return
        }
        
        guard dataTask == nil else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            switch result {
            case .success(let response):
                response.forEach { response in
                    self.photos.append(Photo(from: response))
                }
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self
                    )
                let nextPage = (pageCount ?? 0) + 1
                self.dataTask = nil
                self.pageCount = nextPage
            case .failure(let error):
                print("ImageListService Error in \(#function): error = \(error)")
            }
            self.dataTask = nil
            completion(result)
        }
        self.dataTask = task
        task.resume()
    }
    
    func makePhotosRequest() -> URLRequest? {
        let nextPage = (pageCount ?? 0) + 1
        pageCount = nextPage
        
        guard var urlComponents = URLComponents(string: Constants.defaultBaseAPIURLString + "/photos") else {
            print("Failed construct URL in \(#function)")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: nextPage.description)
        ]
        
        guard let url = urlComponents.url?.absoluteString else {
            print("Failed construct URL in \(#function)")
            assertionFailure("Failed to create URL")
            return nil
        }
        
        let request = builder.makeHTTPRequest(path: url, httpMethod: "GET", baseURLString: Constants.defaultBaseAPIURLString)
        return request
    }
}
