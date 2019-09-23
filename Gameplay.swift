import SpriteKit


class Gameplay: SKScene {
    
    var doughnutArray: [String] = []
    var settingHard: Bool = false
    var settingEasy: Bool = true
    let correctDoughtnut: Int = 20
    var updatedDoughnutValue: Int = 0
    var zPositionForWinningDoughnut: CGFloat = 0
    
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
    
    
    var score = 0
    var previousScore = UserDefaults.standard.integer(forKey: HelperStrings.existingScore.rawValue)
    
    lazy var scoreLabel: SKLabelNode = {
        
        var label = SKLabelNode(fontNamed: HelperStrings.labelFont.rawValue)
        label.fontSize = CGFloat.universalFont(size: 40)
        label.zPosition = 3
        label.color = SKColor.white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.text = "\(score)"
        return label
    }()

    lazy var countdownLabel: SKLabelNode = {
        
        var label = SKLabelNode(fontNamed: HelperStrings.labelFont.rawValue)
        label.fontSize = CGFloat.universalFont(size: 40)
        label.zPosition = 3
        label.color = SKColor.white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.text = "00:00"
        return label
    }()
    
    var counter: Int = 0
    var counterTimer = Timer()
    var counterStartValue = 05
    
    var isGameOver: Bool = false

    
    func startCounter() {
        
        counterTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(decrimentCounter), userInfo: nil, repeats: true)
    }
    
    
    func stopCounter() {
        
        counterTimer.invalidate()
    }

    @objc func decrimentCounter() {
        
        let minutes = counter / 60
        let seconds = counter % 60
        let secondsText = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        let minutesText = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        
        if !isGameOver {
            
            if counter <= 0 {
                stopCounter()
                gameOver()
            }
            
            counter -= 1
            countdownLabel.text = String("\(minutesText):\(secondsText)")
        }
    }

    
    override func didMove(to view: SKView) {
        
        setupDoughnuts()
        setupNodes()
        addNodes()
        counter = counterStartValue
        clearScore()
        startCounter()
        Stats.shared.setBestScore(0)
    }
    
    func refreshDoughnut() {
        doughtnutValueDeductionReset()
        removeDoughnutsFromScene()
        clearDoughnutArray()
        setupDoughnuts()
        counter = counterStartValue
        startCounter()
    }

    
    func setupDoughnuts() {
        
        for i in 0...19 {
            
            let imageNamed = "Donut\(Int(CGFloat.random(1.0, max: 96)))"
            doughnutArray.append(imageNamed)
            
            let doughnut = Button(imageNamed: imageNamed) {
                print("Wrong Doughnut Pressed")
                self.manageWrongDonughtPressed()
            }
            doughnut.name = imageNamed
            doughnut.scaleTo(screenWithPercentage: CGFloat.random(0.25, max: 0.5))
            doughnut.zPosition = CGFloat(i)
            zPositionForWinningDoughnut = doughnut.zPosition
            doughnut.position = CGPoint(x: ScreenSize.width * CGFloat.random(0.1, max: 0.9), y: ScreenSize.height * CGFloat.random(0.1, max: 0.9))
            doughnut.button.popUp(after: CGFloat.random(0.01, max: 0.2), sequenceNumber: 0) //"i" is too slow
            addChild(doughnut)
        }
        
        let imageNamed = "Donut\(Int(CGFloat.random(1.0, max: 96)))"
        
        let correctDoughnut = Button(imageNamed: imageNamed) {
            print("Correct Doughnut Pressed !")
            self.manageCorrectDonughtPress()
        }
        correctDoughnut.name = "Donut101"
        correctDoughnut.scaleTo(screenWithPercentage: CGFloat.random(0.51, max: 0.7))
        correctDoughnut.zPosition = zPositionForWinningDoughnut + 1
        correctDoughnut.position = CGPoint(x: ScreenSize.width * CGFloat.random(0.1, max: 0.9), y: ScreenSize.height * CGFloat.random(0.1, max: 0.9))
        correctDoughnut.button.popUp(after: CGFloat.random(0.01, max: 0.2), sequenceNumber: 0)
        addChild(correctDoughnut)
        
    }
    
    func setupNodes() {
        
        background.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.5)   //BOTTOM LEFT CORNER
        scoreLabel.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.8)
        countdownLabel.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.9)
    }
    
    
    func addNodes() {
        
        addChild(background)
        addChild(scoreLabel)
        addChild(countdownLabel)
    }
    
    func removeDoughnutsFromScene() {
        
        for tempDoughnut in doughnutArray {
            enumerateChildNodes(withName: "//*") { (node, stop) in
                if node.name == tempDoughnut || node.name == "Donut101" {
                    node.removeFromParent()
                }
            }
        }
    }

    
    func manageCorrectDonughtPress() {
    
        stopCounter()
        addToDoughnutScore()
        updateScoreLabel()
        refreshDoughnut()
    }
    
    
    
    func updateScoreLabel() {
        
        scoreLabel.text = "\(score)"
    }
    
    
    
    func addToDoughnutScore() {
        
        var currentDoughtnutValue: Int = 0
        
       
        if updatedDoughnutValue != 0 && updatedDoughnutValue - correctDoughtnut == 0 {
            print("minimum doughtnut value threshold reached")
            currentDoughtnutValue = 5
        }
        
        //AVOID MINUS NUMBERS
        else if updatedDoughnutValue != 0 {
            currentDoughtnutValue = correctDoughtnut - updatedDoughnutValue

        } else {
            currentDoughtnutValue = correctDoughtnut
            print("no decrease in the value of doughnuts on the FTSE100 today !")
            
        }
        score = score + currentDoughtnutValue
        UserDefaults.standard.set(score, forKey: HelperStrings.existingScore.rawValue)
    }
    
    func doughtnutValueDeductionReset() {
        
        updatedDoughnutValue = 0
    }
    
    func manageWrongDonughtPressed() {
        
        var i: Int = 0
        var doughnuts: [String] = []
        
        
        if settingHard == true {
            doughnuts = [self.doughnutArray.randomElement() ?? ""]
        } else if settingEasy == true {                             //DEDUCT 1 DOUGHNUT PER WRONG PRESS (FASTER GAME)
            doughnuts = Array(self.doughnutArray.prefix(5))
        }
        if !self.doughnutArray.isEmpty {
            while i <= 4 {
                for doughtnutExtracted in doughnuts {
                    enumerateChildNodes(withName: "//*") { (node, stop) in
                        if node.name == doughtnutExtracted {
                            self.doughnutArray.removeAll { $0 == node.name }
                            node.removeFromParent()
                        }
                    }
                    i = i + 1
                }
            }
            doughnutScorePunishement()
        } else {
            print("Keep trying")
            //gameOver()
        }
    }
    
    func doughnutScorePunishement() {
        
        updatedDoughnutValue = updatedDoughnutValue + 5
        
        if score <= 0 {
            print("score at zero")
        } else {
            score = score - 5
            UserDefaults.standard.set(score, forKey: HelperStrings.existingScore.rawValue)
        }
        updateScoreLabel()
    }
    
    
    func gameOver() {

        isGameOver = true
        Stats.shared.setScore(score)
        stopCounter()
        clearDoughnutArray()
        Manager.shared.transition(self, toScene: .gameOver, transition: SKTransition.moveIn(with: .right, duration: 0.5))
        Stats.shared.rateGameRequest()
    }
    

    func previousDonughtScoreExist() -> Int {
        
        if previousScore != 0 {
            return previousScore
        } else {
            return 0
        }
    }
    
    
    func clearScore() {
        
        UserDefaults.standard.set(0, forKey: HelperStrings.existingScore.rawValue)
    }
    
    
    func clearDoughnutArray() {
        
        self.doughnutArray.removeAll()
    }
    
    
    
}

