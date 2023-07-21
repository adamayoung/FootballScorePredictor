import SwiftUI

struct ContentView: View {

    var body: some View {
        #if os(macOS)
        content
            .frame(minWidth: 600, minHeight: 500)
        #else
        NavigationStack {
            content
                .navigationTitle("Football Score Predictor")
                .navigationBarTitleDisplayMode(.inline)
        }
        #endif
    }

    private var content: some View {
        PredictScoreView()
    }

}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }

}
