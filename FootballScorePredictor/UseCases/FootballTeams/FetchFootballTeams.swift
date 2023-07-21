import Foundation

final class FetchFootballTeams: FetchFootballTeamsUseCase {

    init() { }

    func execute() throws -> [FootballTeam] {
        let filePath = try Self.teamsFilePath()
        let teamNames = try Self.fetchTeamNames(from: filePath)
        let footballTeams = teamNames.map(FootballTeam.init)
        return footballTeams
    }

}

extension FetchFootballTeams {

    private static func teamsFilePath() throws -> URL {
        guard let filePath = Bundle.main.url(forResource: "teams", withExtension: "json") else {
            throw NSError(domain: "footballscorepredictor", code: -1)
        }

        return filePath
    }

    private static func fetchTeamNames(from filePath: URL) throws -> [String] {
        let data = try Data(contentsOf: filePath)
        let jsonDecoder = JSONDecoder()
        let teamNames = try jsonDecoder.decode([String].self, from: data)
        return teamNames
    }

}
