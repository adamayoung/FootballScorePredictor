import CreateML
import Foundation

// Get a list of CSV files from the playground's `Resources` folder.
let fileNames = ["epl-2022", "epl-2021", "epl-2020", "epl-2019", "epl-2018", "epl-2017", "epl-2016"]
let fileURLs = fileNames.map { fileName in
    Bundle.main.url(forResource: fileName, withExtension: "csv")!
}

// Create a data table from the CSV files.
let dataTables = try fileURLs.map { fileURL in
    try MLDataTable(contentsOf: fileURL)
}

var dataTable = dataTables[0]
for index in 1...(dataTables.count - 1) {
    dataTable.append(contentsOf: dataTables[index])
}

print(dataTable)

// Isolate the Relevant Model Data
let homeTeamScoreRegressorColumns = ["homeTeamScore", "homeTeam", "awayTeam"]
let awayTeamScoreRegressorColumns = ["awayTeamScore", "homeTeam", "awayTeam"]
let homeTeamScoreRegressorTable = dataTable[homeTeamScoreRegressorColumns]
let awayTeamScoreRegressorTable = dataTable[awayTeamScoreRegressorColumns]
print(homeTeamScoreRegressorTable)
print(awayTeamScoreRegressorTable)

// Divide the Data for Training and Evaluation
let (homeTeamRegressorEvaluationTable, homeTeamRegressorTrainingTable) = homeTeamScoreRegressorTable.randomSplit(by: 0.20, seed: 5)
let (awayTeamRegressorEvaluationTable, awayTeamRegressorTrainingTable) = awayTeamScoreRegressorTable.randomSplit(by: 0.20, seed: 5)

// Train the Home Score Regressor
let homeScoreRegressor = try MLLinearRegressor(trainingData: homeTeamRegressorTrainingTable, targetColumn: "homeTeamScore")
let awayScoreRegressor = try MLLinearRegressor(trainingData: awayTeamRegressorTrainingTable, targetColumn: "awayTeamScore")

// Evaluate the Regressors
let homeScoreRegressorEvalutation = homeScoreRegressor.evaluation(on: homeTeamRegressorEvaluationTable)
let awayScoreRegressorEvalutation = awayScoreRegressor.evaluation(on: awayTeamRegressorEvaluationTable)

print("homeScoreRegressor maximumError: \(homeScoreRegressorEvalutation.maximumError)")
print("awayScoreRegressor maximumError: \(awayScoreRegressorEvalutation.maximumError)")

// Save the models
let homePath = FileManager.default.homeDirectoryForCurrentUser
let desktopPath = homePath.appendingPathComponent("Desktop")

let homeScoreRegressorMetadata = MLModelMetadata(author: "Adam Young",
                                                 shortDescription: "Predicts the home score of two Football teams.",
                                                 version: "1.0")
let awayScoreRegressorMetadata = MLModelMetadata(author: "Adam Young",
                                                 shortDescription: "Predicts the away score of two Football teams.",
                                                 version: "1.0")

try homeScoreRegressor.write(to: desktopPath.appendingPathComponent("HomeFootballTeamScoreRegressor.mlmodel"),
                             metadata: homeScoreRegressorMetadata)
try awayScoreRegressor.write(to: desktopPath.appendingPathComponent("AwayFootballTeamScoreRegressor.mlmodel"),
                             metadata: awayScoreRegressorMetadata)

// Generate a unique list of team names
let allTeamNames = dataTable.rows.flatMap { row in
    guard
        let homeTeam = row["homeTeam"]?.stringValue,
        let awayTeam = row["awayTeam"]?.stringValue
    else {
        return [String]()
    }

    return [homeTeam, awayTeam]
}

let teamNames = Array(Set(allTeamNames)).sorted()
let jsonEncoder = JSONEncoder()
let teamNamesData = try jsonEncoder.encode(teamNames)

// Save the unique list of team names
let teamNamesFileURL = desktopPath.appendingPathComponent("teams.json")
try teamNamesData.write(to: teamNamesFileURL)
print("Team names successfully saved at \(teamNamesFileURL.path()).")
