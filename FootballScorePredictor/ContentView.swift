import SwiftUI

struct ContentView: View {

    var body: some View {
        PredictScoreView()
            .frame(minWidth: 600, minHeight: 500)
    }

}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }

}
