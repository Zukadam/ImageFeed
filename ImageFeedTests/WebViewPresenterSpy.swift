import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var loadAuthViewCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func loadAuthView() {
        loadAuthViewCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
