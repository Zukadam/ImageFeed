import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError
    case urlSessionError
    case decodingError(Error)
    case tokenError
    case raceError
    case responseError(Error)
}
