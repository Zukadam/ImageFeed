import Foundation

public protocol WebViewPresenterProtocol {
    // MARK: - Public Properties
    var view: WebViewViewControllerProtocol? { get set }
    // MARK: - Public Methods
    func loadAuthView()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
