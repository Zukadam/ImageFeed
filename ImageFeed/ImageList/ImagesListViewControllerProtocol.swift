import Foundation

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    func updateTableViewWithAnimation()
    func updateLikeButton(for indexPath: IndexPath, with isLiked: Bool)
}
