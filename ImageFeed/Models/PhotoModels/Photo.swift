import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: URL?
    let largeImageURL: URL?
    var isLiked: Bool
    
    init(id: String, size: CGSize, createdAt: String?, welcomeDescription: String?, thumbImageURL: URL?, largeImageURL: URL?, isLiked: Bool) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
    
    init(from result: PhotoResult) {
        self.id = result.id
        self.size = CGSize(width: result.width, height: result.height)
        self.createdAt = result.createdAt
        self.welcomeDescription = result.description
        self.thumbImageURL = result.urls.thumb
        self.largeImageURL = result.urls.full
        self.isLiked = result.likedByUser
    }
}

//[
//  {
//    "id": "LBI7cgq3pbM",
//    "created_at": "2016-05-03T11:00:28-04:00",
//    "updated_at": "2016-07-10T11:00:01-05:00",
//    "width": 5245,
//    "height": 3497,
//    "color": "#60544D",
//    "blur_hash": "LoC%a7IoIVxZ_NM|M{s:%hRjWAo0",
//    "likes": 12,
//    "liked_by_user": false,
//    "description": "A man drinking a coffee.",
//    "user": {
//      // ...
//    },
//    // ...
//    "urls": {
//      "raw": "https://images.unsplash.com/face-springmorning.jpg",
//      "full": "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg",
//      "regular": "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg&w=1080&fit=max",
//      "small": "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg&w=400&fit=max",
//      "thumb": "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg&w=200&fit=max"
//    },
//    // ...
//  },
//  // ... more photos
//]

