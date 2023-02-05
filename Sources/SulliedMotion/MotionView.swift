import SwiftUI
import CoreMotion

/// Summary and controls for motion data including the option of exporting historic motion data to a file.
public struct MotionView<ModelType: MotionProtocol>: View {
    /// Model providing motion data and interactivity.
    @ObservedObject var model: ModelType
    @State var isMeasuring: Bool = false
    @State var isFileManagerPresented = false

    private var latestTimestamp: String {
        get {
            guard let timestamp = model.latest?.timestamp else {
                return "nil"
            }
            return String(format: "%.2f", timestamp)
        }
    }

    private var minimumDescription: String {
        get {
            guard let minimum = model.minimum else {
                return "nil, nil, nil"
            }
            return String(format: "%.2f, %.2f, %.2f", minimum.0, minimum.1, minimum.2)
        }
    }

    private var maximumDescription: String {
        get {
            guard let maximum = model.maximum else {
                return "nil, nil, nil"
            }
            return String(format: "%.2f, %.2f, %.2f", maximum.0, maximum.1, maximum.2)
        }
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Button(action: model.toggle) {
                Text(model.recording ? "Stop" : "Start")
            }

            VStack(alignment: .leading) {
                HStack {
                    Text("Latest")
                    Spacer()
                    Text("\(latestTimestamp)")
                }
                HStack {
                    Text("Count")
                    Spacer()
                    Text("\(model.count)")
                }
                HStack {
                    Text("Minimum")
                    Spacer()
                    Text(minimumDescription)
                }
                HStack {
                    Text("Maximum")
                    Spacer()
                    Text(maximumDescription)
                }
                HStack {
                    Text("Now")
                    Spacer()
                    AccelerationView(acceleration: model.latest)
                }
            }.padding()

            Button(action: { self.isFileManagerPresented = true }) {
                Text("Export")
            }.fileExporter(isPresented: $isFileManagerPresented,
                           document: MotionFile(model.history),
                           contentType: .json,
                           defaultFilename: MotionFile.defaultFileName(start: Date.now),
                           onCompletion: { result in
                switch result {
                case .success(let url):
                    NSLog("DEBUG: Saved as \(url.lastPathComponent)")
                case .failure(let error):
                    NSLog("ERROR: \(error)")
                }
            })
        }.padding()
    }

    /// Creates a summary with controls for motion data based on a model providing the data and interactivity.
    public init(model: ModelType) {
        self.model = model
    }
}

struct MotionView_Previews: PreviewProvider {
    static var previews: some View {
        MotionView(model: DesignTimeMotionModel())
    }
}
