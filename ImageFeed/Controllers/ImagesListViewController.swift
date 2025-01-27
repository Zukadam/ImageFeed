import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private Properties
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    private let imagesListService: ImagesListService = ImagesListService.shared
    private var photos: [Photo] = []
    private let currentDate = Date()
    //    private var imagesListServiceObserver: NSObjectProtocol?
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            //            let image = UIImage(named: photos[indexPath.row])
            //                        viewController.image = image
            let photo = photos[indexPath.row]
            viewController.photo = photo
//            UIBlockingProgressHUD.show()
//            guard let singleImage = photo.largeImageURL else { return }
//            loadImage(from: singleImage) { [weak viewController] image in
//                guard let viewController else { return }
//                UIBlockingProgressHUD.dismiss()
//                viewController.image = image
//            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    private func setTableView() {
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imagesListService.fetchPhotosNextPage { [weak self] result in
            self?.onLoadNextPage(result: result)
        }
    }
}

// MARK: - Extensions
// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    // Вероятно надо изменить configCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListViewCell.reuseIdentifier, for: indexPath)
        
        guard let imageListViewCell = cell as? ImagesListViewCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListViewCell, with: indexPath)
        imageListViewCell.delegate = self
        
        return imageListViewCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == photos.count - 1 else { return }
        imagesListService.fetchPhotosNextPage { [weak self] result in
            self?.onLoadNextPage(result: result)
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

// MARK: - Cell Configuration and Data Loading
extension ImagesListViewController {
    func configCell(for cell: ImagesListViewCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let url = photo.thumbImageURL
        // TODO:
//        cell.cellImage.kf.setImage(with: <#T##Source?#>, placeholder: <#T##(any Placeholder)?#>)
        cell.cellImage.kf.setImage(with: url)
        cell.dateLabel.text = dateFormatter.string(from: Date())
        cell.likeButton.setImage(photo.isLiked ? UIImage(named: "likeButtonOn") : UIImage(named: "likeButtonOff"), for: .normal)
    }
    
    func onLoadNextPage(result: Result<[PhotoResult], Error>) {
        switch result {
        case .success(let newPhotos):
            photos += newPhotos.map { Photo(from: $0) }
            tableView.reloadData()
        case let .failure(error):
            NSLog(error.localizedDescription)
        }
    }
}

// MARK: - ImagesListViewCellDelegate
extension ImagesListViewController: imageListViewCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] response in
            guard let self else { return }
            switch response {
            case.success(let currentLike):
                self.photos[indexPath.row].isLiked = currentLike
                cell.refreshLikeImage(to: currentLike)
                UIBlockingProgressHUD.dismiss()
            case.failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("Cant refresh like condition \(error)")
            }
        }
    }
}
