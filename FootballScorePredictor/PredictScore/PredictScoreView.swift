import SwiftUI

struct PredictScoreView: View {

    @StateObject var viewModel = PredictScoreViewModel()

    private var predictedScoreText: String {
        guard let predictedScore = viewModel.predictedScore else {
            return ""
        }

        return "\(predictedScore.home) - \(predictedScore.away)"
    }

    var body: some View {
        Grid(alignment: .top, horizontalSpacing: 20, verticalSpacing: 20) {
            GridRow {
                Text("Home")
                    .font(.title)

                Text("Away")
                    .font(.title)
            }

            GridRow {
                Picker("Home", selection: $viewModel.homeTeamSelection) {
                    ForEach(viewModel.homeTeams) { footballTeam in
                        Text(footballTeam.name)
                            .tag(footballTeam)
                    }
                }
                .labelsHidden()

                Picker("Away", selection: $viewModel.awayTeamSelection) {
                    ForEach(viewModel.awayTeams) { footballTeam in
                        Text(footballTeam.name)
                            .tag(footballTeam)
                    }
                }
                .labelsHidden()
            }

            GridRow {
                Image(viewModel.homeTeamSelection.name)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)

                Image(viewModel.awayTeamSelection.name)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
            }

            GridRow {
                VStack(alignment: .center) {
                    Text(verbatim: " \(predictedScoreText) ")
                        .font(.system(size: 60))
                        .bold()
                        .foregroundColor(.primary)

                    Text("Prediction")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .gridCellColumns(2)
                .opacity(predictedScoreText.isEmpty ? 0 : 1)
            }
        }
        .padding()
        .frame(maxWidth: 500)
        .opacity(viewModel.isLoading ? 0 : 1)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }

}

struct PredictScoreView_Previews: PreviewProvider {

    private static let allFootballTeams = [
        FootballTeam(name: "Arsenal"),
        FootballTeam(name: "Chelsea"),
        FootballTeam(name: "Leeds"),
        FootballTeam(name: "Liverpool")
    ]

    static var previews: some View {
        Group {
            PredictScoreView(
                viewModel: PredictScoreViewModel(
                    allFootballTeams: allFootballTeams,
                    homeTeamSelection: allFootballTeams[0],
                    awayTeamSelection: allFootballTeams[1],
                    predictedScore: .init(home: 2, away: 3)
                )
            )
        }
    }

}
