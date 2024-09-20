import UIKit

final class ProfileViewController: UIViewController {
    
//    @IBOutlet private var avatarImageView: UIImageView!
//    @IBOutlet private var logoutButton: UIButton!
//    @IBOutlet private var nameLabel: UILabel!
//    @IBOutlet private var loginNameLabel: UILabel!
//    @IBOutlet private var descriptionLabel: UILabel!
//    
//    @IBAction private func didTapLogoutButton(_ sender: Any) {
//    }
    var constrains: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let avatarImage = UIImage(named: "avatar")
        let avatarImageView = UIImageView(image: avatarImage)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        let topAvatarImageViewConstrain = avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        let leadingAvatarImageViewConstrain = avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        let widthAvatarImageViewConstrain = avatarImageView.widthAnchor.constraint(equalToConstant: 70)
        let heightAvatarImageViewConstrain = avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: 1.0/1.0)
        constrains.append(
            contentsOf: [
                topAvatarImageViewConstrain,
                leadingAvatarImageViewConstrain,
                widthAvatarImageViewConstrain,
                heightAvatarImageViewConstrain
            ]
        )
        
        let logoutButton = UIButton()
        let logoutButtonImage = UIImage(named: "Exit")
        logoutButton.setImage(logoutButtonImage, for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        let widthLogoutButtonConstrain = logoutButton.widthAnchor.constraint(equalToConstant: 44)
        let heightLogoutButtonConstrain = logoutButton.heightAnchor.constraint(equalToConstant: 44)
        let trailingLogoutButtonConstrain = logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        let centerYLogoutButtonConstrain = logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        constrains.append(
            contentsOf: [
                widthLogoutButtonConstrain,
                heightLogoutButtonConstrain,
                centerYLogoutButtonConstrain,
                trailingLogoutButtonConstrain
            ]
        )
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhiteIOS
        nameLabel.font = .boldSystemFont(ofSize: 23.0)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        let topNameLabelConstrain = nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8)
        let leadingNameLabelConstrain = nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        constrains.append(
            contentsOf: [
                topNameLabelConstrain,
                leadingNameLabelConstrain,
            ]
        )
        
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = .ypGrayIOS
        loginNameLabel.font = .systemFont(ofSize: 13.0)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        let topLoginNameLabelConstrain = loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        let leadingLoginNameLabelConstrain = loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        constrains.append(
            contentsOf: [
                topLoginNameLabelConstrain,
                leadingLoginNameLabelConstrain,
            ]
        )
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.textColor = .ypWhiteIOS
        descriptionLabel.font = .systemFont(ofSize: 13.0)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        let topDescriptionLabelConstrain = descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8)
        let leadingDescriptionLabelConstrain = descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        constrains.append(
            contentsOf: [
                topDescriptionLabelConstrain,
                leadingDescriptionLabelConstrain,
            ]
        )
        
        NSLayoutConstraint.activate(constrains)
    }
    
}
