import Foundation

protocol PredictScoreUseCase {

    func execute(homeTeam: String, awayTeam: String) throws -> ScorePrediction

}
