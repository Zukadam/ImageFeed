import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var backButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    
    // MARK: - Private Properties
    private var imageView = UIImageView()
    private var scrollView = UIScrollView()
    
    // MARK: - Public Properties
    var photo: Photo?
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setScrollView()
        
        view.bringSubviewToFront(backButton)
        view.bringSubviewToFront(shareButton)
        
        guard let url = photo?.largeImageURL else { return }
        loadImage(by: url)
    }
    
    
    // MARK: - IB Actions
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    private func setScrollView() {
        let scrollView = UIScrollView()
        
        view.layoutIfNeeded()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        scrollView.layoutIfNeeded()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        self.scrollView = scrollView
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let imageResult):
                    completion(imageResult.image)
                case .failure:
                    self.showError()
                }
            }
        }
    }
    
    private func showError() {
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Попробовать ещё раз?",
            firstButtonText: "Повторить", secondButtonText: "Не надо"
        ) { [weak self] in
            guard let self else { return }
            guard let url = photo?.largeImageURL else { return }
            
            imageView.removeFromSuperview()
            
            loadImage(by: url)
        }
        AlertPresenter.showAlert(model: alertModel, vc: self)
    }
    
    private func loadImage(by url: URL) {
        UIBlockingProgressHUD.show()
        imageView = UIImageView()
        imageView.image = UIImage(named: "singleImagePlaceholder")
        imageView.frame.size = image?.size ?? CGSize.zero
        imageView.contentMode = .scaleAspectFit
        self.scrollView.addSubview(imageView)
        loadImage(from: url) { [weak self] image in
            guard let self else { return }
            UIBlockingProgressHUD.dismiss()
            self.image = image
        }
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
