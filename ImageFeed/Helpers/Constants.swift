import Foundation

enum Constants {
    static let accessKey = "7Bl_LZ13dT9Jt_Jx5G21ljVUpR8tCgYwNS-PZb_Okbs"
    static let secretKey = "0fHYczHXUAUUUdxb8EfJCYkmAgjKSF8MtWIVefyKTyQ"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let grantType = "authorization_code"
    
    static let defaultBaseAPIURLString = "https://api.unsplash.com"
    static let defaultBaseURLString = "https://unsplash.com"
    
    static let defaultBaseURL: URL = {
        guard let url = URL(string: defaultBaseAPIURLString) else {
            preconditionFailure("Unable to construct defaultBaseURL")
        }
        return url
    }()
    
    static let unsplashAuthorizeURLString = "\(defaultBaseURLString)/oauth/authorize"
    static let unsplashGetTokenURLString = "\(defaultBaseURLString)/oauth/token"
    static let unsplashGetProfileURLString = "\(defaultBaseURLString)/me"
    
    static let defaultAvatarURLString = "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32&s=0ad68f44c4725d5a3fda019bab9d3edc"
    
    static let showAuthenticationScreenSegueIdentifier = "AuthViewControllerID"
    static let navigationController = "NavigationControllerID"
    static let tabBarViewController = "TabBarViewController"
    static let webViewViewController = "WebViewViewControllerID"
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let showLoginFlowSegueIdentifier = "ShowLoginFlow"
    static let showWebViewSegueIdentifier = "ShowWebView"
    static let showSingleImageSegueIdentifier = "ShowSingleImage"
}
