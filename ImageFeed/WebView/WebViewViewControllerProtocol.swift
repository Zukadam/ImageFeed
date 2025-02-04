import Foundation

public protocol WebViewViewControllerProtocol: AnyObject {
    // MARK: - Public properties
    var presenter: WebViewPresenterProtocol? { get set }
    // MARK: - Public methods
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
