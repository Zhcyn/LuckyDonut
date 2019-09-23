import Foundation
import SpriteKit
import StoreKit
class Stats {
    private init() {}
    static let shared = Stats()
    func setScore(_ value: Int) {
        if value > getBestScore() {     
            setBestScore(value)
        }
        UserDefaults.standard.set(value, forKey: HelperStrings.kScore.rawValue)
        UserDefaults.standard.synchronize()
    }
    func getScore() -> Int {
        return UserDefaults.standard.integer(forKey: HelperStrings.kScore.rawValue)
    }
    func setBestScore(_ value: Int) {
        UserDefaults.standard.set(value, forKey: HelperStrings.kBestScore.rawValue)
        UserDefaults.standard.synchronize()
    }
    func getBestScore() -> Int {
        return UserDefaults.standard.integer(forKey: HelperStrings.kBestScore.rawValue)
    }
    func setSounds(_ state: Bool) {
        UserDefaults.standard.set(state, forKey: HelperStrings.kSoundState.rawValue)
        UserDefaults.standard.synchronize()     
    }
    func getSound() -> Bool {
        return UserDefaults.standard.bool(forKey: HelperStrings.kSoundState.rawValue)
    }
    func saveMusicVolume(_ value: Float) {
        UserDefaults.standard.set(value, forKey: HelperStrings.kMusicVolume.rawValue)
        UserDefaults.standard.synchronize()
    }
    func getMusicVolume() -> Float {
        return UserDefaults.standard.float(forKey: HelperStrings.kMusicVolume.rawValue)
    }
    func rateGameRequest() {
        let personalBest: Int = Stats.shared.getBestScore()
        if personalBest != 0 || personalBest == personalBest + 200 {
            SKStoreReviewController.requestReview()
        }
    }
}
