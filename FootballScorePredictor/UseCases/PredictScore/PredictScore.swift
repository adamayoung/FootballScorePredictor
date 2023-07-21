import CoreML
import Foundation

final class PredictScore: PredictScoreUseCase {

    init() { }

    func execute(homeTeam: String, awayTeam: String) throws -> ScorePrediction {
        let homeScore = try predictHomeTeamScore(for: homeTeam, against: awayTeam)
        let awayScore = try predictAwayTeamScore(for: awayTeam, against: homeTeam)

        return ScorePrediction(homeScore: homeScore, awayScore: awayScore)
    }

}

extension PredictScore {

    private func predictHomeTeamScore(for homeTeam: String, against awayTeam: String) throws -> Int {
        let model = try HomeFootballTeamScoreRegressor(configuration: .init())
        let output = try model.prediction(homeTeam: homeTeam, awayTeam: awayTeam)
        let predictedScore = Int(output.homeTeamScore)
        return predictedScore
    }

    private func predictAwayTeamScore(for awayTeam: String, against homeTeam: String) throws -> Int {
        let model = try AwayFootballTeamScoreRegressor(configuration: .init())
        let output = try model.prediction(homeTeam: homeTeam, awayTeam: awayTeam)
        let predictedScore = Int(output.awayTeamScore)
        return predictedScore
    }

}
