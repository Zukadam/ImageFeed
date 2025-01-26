import UIKit
import Kingfisher

final class ImagesListViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Public Properties
    weak var delegate: imageListViewCellDelegate?
    
    // MARK: - Private Properties
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Overrides Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    // MARK: - IB Actions
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: - Public Methods
    func refreshLikeImage(to isLike: Bool) {
        likeButton.setImage(isLike ? UIImage(named: "likeButtonOn") : UIImage(named: "likeButtonOff"), for: .normal)
    }
}


// MARK: - IB Outlets

// MARK: - Public Properties

// MARK: - Private Properties

// MARK: - Initializers

// MARK: - Overrides Methods

// MARK: - IB Actions

// MARK: - Public Methods

// MARK: - Private Methods
