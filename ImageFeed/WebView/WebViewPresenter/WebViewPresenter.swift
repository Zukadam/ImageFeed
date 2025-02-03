import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    // MARK: - Public Properties
    weak var view: WebViewViewControllerProtocol?
    private let authHelper: AuthHelperProtocol
    
    // MARK: - Public Methods
    func loadAuthView() {
        guard let request = authHelper.authRequest() else { return }
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    // MARK: - Initializers
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
}
