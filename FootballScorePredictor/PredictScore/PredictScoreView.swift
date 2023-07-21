import SwiftUI

struct PredictScoreView: View {

    @StateObject var viewModel = PredictScoreViewModel()

    private var gridHorizontalSpacing: CGFloat {
        #if os(macOS)
        return 20
        #else
        return 70
        #endif
    }

    var body: some View {
        Grid(alignment: .top, horizontalSpacing: gridHorizontalSpacing, verticalSpacing: 20) {
            GridRow {
                Text("Home")
                    .font(.title)

                Text("Away")
                    .font(.title)
            }

            GridRow {
                teamPicker("Home", selection: $viewModel.homeTeamSelection, from: viewModel.homeTeams)

                teamPicker("Away", selection: $viewModel.awayTeamSelection, from: viewModel.awayTeams)
            }

            GridRow {
                crest(for: viewModel.homeTeamSelection)

                crest(for: viewModel.awayTeamSelection)
            }

            GridRow {
                predicatedScoreRow(for: viewModel.predictedScore)
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

    private func teamPicker(_ titleKey: LocalizedStringKey, selection: Binding<FootballTeam?>,
                            from footballTeams: [FootballTeam]) -> some View {
        Picker(titleKey, selection: selection) {
            Text(verbatim: "")
                .tag(nil as FootballTeam?)

            ForEach(footballTeams) { footballTeam in
                Text(footballTeam.name)
                    .tag(footballTeam as FootballTeam?)
            }
        }
        .labelsHidden()
    }

    @ViewBuilder
    private func crest(for footballTeam: FootballTeam?) -> some View {
        #if os(macOS)
        let imageHeight: CGFloat = 150
        #else
        let imageHeight: CGFloat = 100
        #endif

        Image(footballTeam?.name ?? "")
            .resizable()
            .scaledToFit()
            .frame(width: imageHeight, height: imageHeight)
    }

    @ViewBuilder
    private func predicatedScoreRow(for predictedScore: PredictScoreViewModel.PredictedScore?) -> some View {
        let text: String = {
            guard let predictedScore = viewModel.predictedScore else {
                return ""
            }

            return "\(predictedScore.home) - \(predictedScore.away)"
        }()

        VStack(alignment: .center) {
            Text(verbatim: " \(text) ")
                .font(.system(size: 60))
                .bold()
                .foregroundColor(.primary)

            Text("Prediction")
                .font(.body)
                .foregroundColor(.gray)
        }
        .gridCellColumns(2)
        .opacity(text.isEmpty ? 0 : 1)
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
