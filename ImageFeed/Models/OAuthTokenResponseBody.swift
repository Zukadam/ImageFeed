import Foundation

struct OAuthTokenResponseBody: Decodable {
    // MARK: - Public Properties
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    // MARK: - Private Properties
    private enum CodingKeys: String, CodingKey {
        case accessToken
        case tokenType
        case scope
        case createdAt
    }
    
    private enum ParseError: Error {
        case createdAtFailure
    }
    
    // MARK: - Initialisers
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        accessToken = try container.decode(String.self, forKey: .accessToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        scope = try container.decode(String.self, forKey: .scope)
        createdAt = try container.decode(Int.self, forKey: .createdAt)
    }
}
