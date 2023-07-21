import Foundation

protocol FetchFootballTeamsUseCase {

    func execute() throws -> [FootballTeam]

}
