import SpriteKit
class GameOver: SKScene {
    var background: SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: HelperStrings.backgroundImage.rawValue)
        if DeviceType.isiPadAir2 || DeviceType.isiPadMini4 || DeviceType.isiPadPro11 || DeviceType.isiPadPro105 || DeviceType.isiPadPro129 || DeviceType.isiPadPro97 {
            sprite.scaleTo(screenHeightPercentage: 1.0)
        } else {
            sprite.scaleTo(screenHeightPercentage: 1.0)
        }
        sprite.zPosition = 0
        return sprite
    }()
    var title: SKLabelNode = {
        var label = SKLabelNode(fontNamed: HelperStrings.labelFont.rawValue)
        label.fontSize = CGFloat.universalFont(size: 20)
        label.zPosition = 2
        label.color = SKColor.white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.text = "Game Over"
        return label
    }()
    var score: SKLabelNode = {
        var label = SKLabelNode(fontNamed: HelperStrings.labelFont.rawValue)
        label.fontSize = CGFloat.universalFont(size: 20)
        label.zPosition = 2
        label.color = SKColor.white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.text = "Score : \(Stats.shared.getScore())"
        return label
    }()
    var bestScore: SKLabelNode = {
        var label = SKLabelNode(fontNamed: HelperStrings.labelFont.rawValue)
        label.fontSize = CGFloat.universalFont(size: 20)
        label.zPosition = 2
        label.color = SKColor.white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.text = "Best Score : \(Stats.shared.getBestScore())"
        return label
    }()
    lazy var backButton: Button = {
        var button = Button(imageNamed: HelperStrings.buttonBack.rawValue, title: "", buttonAction: {
            Manager.shared.transition(self, toScene: .mainMenu, transition: SKTransition.moveIn(with: .left, duration: 0.5))
        })
        button.zPosition = 1
        button.scaleTo(screenWithPercentage: 0.20)
        return button
    }()
    lazy var replayButton: Button = {
        var button = Button(imageNamed: HelperStrings.buttonReplay.rawValue, buttonAction: {
            Manager.shared.transition(self, toScene: .gameplay, transition: SKTransition.moveIn(with: .left, duration: 0.5))
        })
        button.scaleTo(screenWithPercentage: 0.27)
        button.zPosition = 1
        return button
    }()
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)   
        setupNodes()
        addNodes()
    }
    func setupNodes() {
        background.position = CGPoint.zero
        title.position = CGPoint(x: ScreenSize.width * 0.0, y: ScreenSize.height * 0.25)
        score.position = CGPoint(x: ScreenSize.width * 0.0, y: ScreenSize.height * 0.12)
        bestScore.position = CGPoint(x: ScreenSize.width * 0.0, y: ScreenSize.height * 0.18)
        backButton.position = CGPoint(x: ScreenSize.width * 0.0, y: ScreenSize.height * -0.35)
        replayButton.position = CGPoint(x: ScreenSize.width * 0.0, y: ScreenSize.height * -0.10)
    }
    func addNodes() {
        addChild(background)
        addChild(title)
        addChild(score)
        addChild(bestScore)
        addChild(backButton)
        addChild(replayButton)
    }
}
