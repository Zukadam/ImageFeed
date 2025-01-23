import UIKit

final class ImagesListService {
    
    // MARK: - Public Properties
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Private Properties
    private(set) var profile: Profile?
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    private var lastToken: String?
    private var currentTask: URLSessionTask?
    private (set) var photos: [Photo] = []

    
    private var lastLoadedPage: Int?
    private var pageCount = 1
    
    // ...
    
    // MARK: - Initialisers
    private init() {}
    
    // MARK: - Public Methods
    //    func fetchPhotosNextPage() {
    // Здесь получим страницу номер 1, если ещё не загружали ничего,
    // и следующую страницу (на единицу больше), если есть предыдущая загруженная страница
    //        let nextPage = (lastLoadedPage?.number ?? 0) + 1
    // ...
    
    
    func fetchPhotosNextPage(completion: @escaping (Result<Photo, Error>) -> Void) {
        assert(Thread.isMainThread, "Not in Main tread")
        guard let request = makePhotosRequest() else {
            completion(.failure(NetworkError.urlRequestError))
            return
        }
        
    }
    
    func makePhotosRequest() -> URLRequest? {
        //        let nextPage = (lastLoadedPage ?? 0) + 1
        //        lastLoadedPage = nextPage
        guard var urlComponents = URLComponents(string: Constants.defaultBaseAPIURLString + "photos") else {
            print("Failed construct URL in \(#function)")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: pageCount.description)
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

