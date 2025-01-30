import Foundation

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func loadData()
    func fetchPhotosNextPage()
    func updatePhotos() -> (old: Int, new: Int)
    func likeButtonWasTapped(by indexPath: IndexPath)
}
