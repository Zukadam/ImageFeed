import Foundation

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
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
