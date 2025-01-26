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
            UIBlockingProgressHUD.show()
            guard let singleImage = photo.largeImageURL else { return }
            loadImage(from: singleImage) { [weak viewController] image in
                UIBlockingProgressHUD.dismiss()
                viewController?.image = image
            }
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
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListViewCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListViewCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == photos.count - 1 else { return }
        imagesListService.fetchPhotosNextPage { [weak self] result in
            self?.onLoadNextPage(result: result)
        }
    }
}

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

extension ImagesListViewController {
    func configCell(for cell: ImagesListViewCell, with indexPath: IndexPath) {
        cell.cellImage.kf.setImage(with: photos[indexPath.row].thumbImageURL)
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "ActiveLikeButton") : UIImage(named: "NonActiveLikeButton")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    
    //    func configCell(for cell: ImagesListViewCell, with indexPath: IndexPath, from data: [Photo]) {
    //        cell.configCell(for: cell, with: indexPath, from: data)
    //        guard let tableView else {return}
    //        tableView.reloadRows(at: [indexPath], with: .automatic)
    //    }
    
    func onLoadNextPage(result: Result<[PhotoResult], Error>) {
        switch result {
        case .success(let newPhotos):
            photos += newPhotos.map { Photo(from: $0) }
            tableView.reloadData()
        case let .failure(error):
            NSLog(error.localizedDescription)
        }
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let imageResult):
                completion(imageResult.image)
            case .failure:
                completion(nil)
            }
        }
    }
}
