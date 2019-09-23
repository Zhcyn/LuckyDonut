import Foundation
import SpriteKit
class Button: SKNode {
    var button: SKSpriteNode
    private var mask: SKSpriteNode
    private var cropNode: SKCropNode
    private var action: () -> Void  
    var isEnabled = true
    var titleLabel: SKLabelNode?    
    init(imageNamed: String, title: String? = "", buttonAction: @escaping () -> Void) {
        button = SKSpriteNode(imageNamed: imageNamed)
        titleLabel = SKLabelNode(text: title)
        mask = SKSpriteNode(color: UIColor.black, size: button.size)
        mask.alpha = 0
        cropNode = SKCropNode()
        cropNode.maskNode = button
        cropNode.zPosition = 3
        cropNode.addChild(mask)
        action = buttonAction
        super.init()
        isUserInteractionEnabled = true
        setupNodes()
        addNodes()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupNodes() {
        button.zPosition = 0
        if let titleLabel = titleLabel {
            titleLabel.fontName = HelperStrings.labelFont.rawValue
            titleLabel.fontSize = CGFloat.universalFont(size: 20)
            titleLabel.fontColor = SKColor.white
            titleLabel.zPosition = 1
            titleLabel.horizontalAlignmentMode = .center
            titleLabel.verticalAlignmentMode = .center
        }
    }
    func addNodes() {
        addChild(button)
        if let titleLabel = titleLabel {
            addChild(titleLabel)
        }
        addChild(cropNode)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled == true {
            mask.alpha = 0.5
            run(SKAction.scale(to: 0.95, duration: 0.05))
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled == true {
            for touch in touches {
                let location: CGPoint = touch.location(in: self)
                if button.contains(location) {
                    mask.alpha = 0.5
                    run(SKAction.scale(to: 1.0, duration: 0.05))    
                } else {
                    mask.alpha = 0.0
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled == true {
            for touch in touches {
                let location: CGPoint = touch.location(in: self)
                if button.contains(location) {
                    Manager.shared.run(HelperStrings.buttonMusic.rawValue, onNode: self)
                    disable()
                    action()
                    run(SKAction.sequence([SKAction.wait(forDuration: 0.2), SKAction.run({
                        self.enable()
                    })]))
                }
            }
        }
    }
    func disable() {
        isEnabled = false
        mask.alpha = 0.0
        button.alpha = 0.0
    }
    func enable() {
        isEnabled = true
        mask.alpha = 0.0
        button.alpha = 1.0
    }
    func scaleTo(screenWithPercentage: CGFloat) {
        let aspectRatio = button.size.height / button.size.width
        let screenWidth = ScreenSize.width
        var screenHeight = ScreenSize.height
        if DeviceType.isiPhoneX {
            screenHeight -= 80
        }
        button.size.width = screenWidth * screenWithPercentage
        button.size.height = button.size.width * aspectRatio
    }
}
