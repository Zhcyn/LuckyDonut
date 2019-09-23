import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
let stopBackgroundMusicVolumeNotificationName = Notification.Name("stopBackgroundMusicVolumeNotificationName")
let startBackgroundMusicVolumeNotificationName = Notification.Name("startBackgroundMusicVolumeNotificationName")
let startGameplayNotificationName = Notification.Name("startGameplayNotificationName")
let setMusicVolumeNotificationName = Notification.Name("setMusicVolumeNotificationName")
class GameViewController: UIViewController {
    let skView: SKView = {
        let view = SKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var backgroundMusic: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: HelperStrings.backgroundMusic.rawValue, withExtension: HelperStrings.mp3Extension.rawValue) else {
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            return player
        } catch {
            return nil
        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(skView)
        skView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        skView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        skView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        skView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        let scene = MainMenu(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsNodeCount = true
        addNotificationObservers()
        playOrStopBackgroundMusic()
    }
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopBackgroundMusic(_:)), name: stopBackgroundMusicVolumeNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.startBackgroundMusic(_:)), name: startBackgroundMusicVolumeNotificationName, object: nil)
    }
    func playOrStopBackgroundMusic() {
        backgroundMusic?.play()
    }
    @objc func stopBackgroundMusic(_ info: Notification) {      
        if Stats.shared.getSound() {
            backgroundMusic?.stop()
        }
    }
    @objc func startBackgroundMusic(_ info: Notification) {
        if Stats.shared.getSound() {
            backgroundMusic?.play()
        }
    }
}
