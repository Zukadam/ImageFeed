import Foundation

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private(set) var photos: [Photo] = []
    private let imagesListService: ImagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    func loadData() {
        addImagesListServiceObserver()
        
        fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage { _ in }
    }
    
    func updatePhotos() -> (old: Int, new: Int) {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        return (old: oldCount, new: newCount)
    }
    
    func likeButtonWasTapped(by indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        view?.showLoadingIndicator()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] response in
            guard let self else { return }
            view?.hideLoadingIndicator()
            switch response {
            case.success(let isLiked):
                self.photos[indexPath.row].isLiked = isLiked
                view?.updateLikeButton(for: indexPath, with: isLiked)
            case.failure( _):
                break
            }
        }
    }
}

extension ImagesListViewPresenter {
    private func addImagesListServiceObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main,
                using: { [weak self] _ in
                    guard let self = self else { return }
                    view?.updateTableViewWithAnimation()
                }
            )
    }
}
