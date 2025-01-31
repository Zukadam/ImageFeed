import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let imageListPresenter = ImagesListViewPresenter()
        imageListPresenter.view = imagesListViewController
        imagesListViewController.presenter = imageListPresenter
        
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfileViewPresenter()
        
        profilePresenter.view = profileViewController
        profileViewController.presenter = profilePresenter

        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tabProfileActive"),
            selectedImage: nil
        )
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
