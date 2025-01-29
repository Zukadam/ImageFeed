import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private Properties
    private let isoDateFormatter = ISO8601DateFormatter()
    private lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy"
            formatter.locale = Locale(identifier: "ru_RU")
            return formatter
        }()
    private let imagesListService: ImagesListService = ImagesListService.shared
    private var photos: [Photo] = []
    private let currentDate = Date()
    private var imagesListServiceObserver: NSObjectProtocol? = nil
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        addImagesListServiceObserver()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                print("Error in \(#function): Invalid segue destination")
                return
            }
            let photo = photos[indexPath.row]
            viewController.photo = photo
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    private func setTableView() {
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imagesListService.fetchPhotosNextPage { _ in }
    }
    
    private func addImagesListServiceObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main,
                using: { [weak self] _ in
                    guard let self = self else { return }
                    self.updateTableViewAnimated()
                }
            )
    }
    
    private func updateTableViewAnimated() {
        guard let tableView else {
            preconditionFailure("table view doesn't exist")
        }
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

// MARK: - Extensions
// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
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
        imagesListService.fetchPhotosNextPage { _ in }
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
        cell.cellImage.kf.setImage(with: url, placeholder:UIImage(named: "cellPlaceholder"))
        if let photoDate = photos[indexPath.row].createdAt, let date = isoDateFormatter.date(from: photoDate) {
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }
        cell.likeButton.setImage(photo.isLiked ? UIImage(named: "likeButtonOn") : UIImage(named: "likeButtonOff"), for: .normal)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
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
