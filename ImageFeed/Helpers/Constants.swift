import Foundation

enum Constants {
    static let accessKey = "7Bl_LZ13dT9Jt_Jx5G21ljVUpR8tCgYwNS-PZb_Okbs"
    static let secretKey = "0fHYczHXUAUUUdxb8EfJCYkmAgjKSF8MtWIVefyKTyQ"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = defaultBaseURLChecker
    static private var defaultBaseURLChecker: URL {
        guard let url = URL(string: "https://api.unsplash.com") else { preconditionFailure("Unable to construct unsplashUrl") }
        return url
    }
    static let defaultBaseURLString = "https://unsplash.com"
    static let defaultBaseAPIURLString = "https://api.unsplash.com"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashGetTokenURLString = "https://unsplash.com/oauth/token"
    static let unsplashGetProfileURLString = "https://unsplash.com/me"
    static let grantType = "authorization_code"
//    static let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    static let showAuthenticationScreenSegueIdentifier = "AuthViewControllerID"
    static let navigationController = "NavigationControllerID"
    static let tabBarViewController = "TabBarViewController"
    static let webViewViewController = "WebViewViewControllerID"
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let showLoginFlowSegueIdentifier = "ShowLoginFlow"
    static let showWebViewSegueIdentifier = "ShowWebView"
}
