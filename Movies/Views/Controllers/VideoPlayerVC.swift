
import UIKit
import YouTubeiOSPlayerHelper

class VideoPlayerVC: UIViewController {
    private lazy var videoPlayerView: YTPlayerView = {
        let playerView = YTPlayerView()
        playerView.frame = self.view.bounds
        playerView.backgroundColor = .clear
        return playerView
    }()
    
    var videoID: String?
    
    init(videoID: String?) {
        self.videoID = videoID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(videoPlayerView)
        
        if let videoID = videoID {
            videoPlayerView.load(withVideoId: videoID)
        }
    }
    
}
