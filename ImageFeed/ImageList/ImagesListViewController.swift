import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?
    
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
    private let currentDate = Date()
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        
        presenter?.loadData()
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
            let photo = presenter?.photos[indexPath.row]
            viewController.photo = photo
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Public Methods
    func updateTableViewWithAnimation() {
        guard let tableView else {
            preconditionFailure("table view doesn't exist")
        }
        guard let photos = presenter?.updatePhotos() else { return }
        
        if photos.old != photos.new {
            tableView.performBatchUpdates {
                let indexPaths = (photos.old..<photos.new).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func updateLikeButton(for indexPath: IndexPath, with isLiked: Bool) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListViewCell else { return }
        cell.refreshLikeImage(to: isLiked)
    }
    
    // MARK: - Private Methods
    private func setTableView() {
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

// MARK: - Extensions
// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
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
        guard
            let photos = presenter?.photos,
            indexPath.row == photos.count - 1
        else { return }
        presenter?.fetchPhotosNextPage()
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photos = presenter?.photos else { return 0 }
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
        guard let photo = presenter?.photos[indexPath.row] else { return }
        let url = photo.thumbImageURL
        cell.cellImage.kf.setImage(with: url, placeholder:UIImage(named: "cellPlaceholder"))
        if let photoDate = presenter?.photos[indexPath.row].createdAt, let date = isoDateFormatter.date(from: photoDate) {
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
        presenter?.likeButtonWasTapped(by: indexPath)
    }
}
