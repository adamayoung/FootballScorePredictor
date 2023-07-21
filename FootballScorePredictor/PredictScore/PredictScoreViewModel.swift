import Combine
import Foundation

final class PredictScoreViewModel: ObservableObject {

    @Published private(set) var isLoading: Bool = false
    @Published private(set) var allFootballTeams: [FootballTeam] = []
    @Published private(set) var predictedScore: PredictedScore?
    @Published var homeTeamSelection: FootballTeam?
    @Published var awayTeamSelection: FootballTeam?

    var homeTeams: [FootballTeam] {
        allFootballTeams.filter { $0 != awayTeamSelection }
    }
    var awayTeams: [FootballTeam] {
        allFootballTeams.filter { $0 != homeTeamSelection }
    }

    private var cancellables = Set<AnyCancellable>()

    init() {
        Publishers.CombineLatest($homeTeamSelection, $awayTeamSelection)
            .sink { [weak self] (homeTeam, awayTeam) in
                self?.predict(homeTeam: homeTeam, awayTeam: awayTeam)
            }
            .store(in: &cancellables)
    }

    func loadData() {
        guard allFootballTeams.isEmpty else {
            return
        }

        isLoading = true
        defer {
            isLoading = false
        }
        let useCase = FetchFootballTeams()
        do {
            allFootballTeams = try useCase.execute()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    private func predict(homeTeam: FootballTeam?, awayTeam: FootballTeam?) {
        guard
            let homeTeam,
            let awayTeam,
            !homeTeam.name.isEmpty,
            !awayTeam.name.isEmpty
        else {
            self.predictedScore = nil
            return
        }

        let useCase = PredictScore()
        do {
            let prediction = try useCase.execute(homeTeam: homeTeam.name, awayTeam: awayTeam.name)
            self.predictedScore = PredictedScore(home: prediction.homeScore, away: prediction.awayScore)
        } catch let error {
            print(error.localizedDescription)
        }
    }

}

extension PredictScoreViewModel {

    struct PredictedScore {
        let home: Int
        let away: Int
    }

}

extension PredictScoreViewModel {

    convenience init(
        allFootballTeams: [FootballTeam] = [],
        homeTeamSelection: FootballTeam? = nil,
        awayTeamSelection: FootballTeam? = nil,
        predictedScore: PredictedScore? = nil
    ) {
        self.init()
        self.allFootballTeams = allFootballTeams
        if let homeTeamSelection {
            self.homeTeamSelection = homeTeamSelection
        }

        if let awayTeamSelection {
            self.awayTeamSelection = awayTeamSelection
        }

        self.predictedScore = predictedScore
    }

}
