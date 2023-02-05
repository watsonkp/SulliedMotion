import SwiftUI
import UniformTypeIdentifiers

/// A file document emitting motion data as a JSON encoded file.
struct MotionFile: FileDocument {
    static var readableContentTypes: [UTType] = [UTType.json]
    private let motion: [MotionValue]

    private struct MotionValue: Encodable {
        let timestamp: TimeInterval
        let x: Double
        let y: Double
        let z: Double
    }

    /// Creates a file document based on the given motion data.
    init(_ history: [Motion]) {
        self.motion = history.map({ MotionValue(timestamp: $0.timestamp,
                                                x: $0.acceleration.x,
                                                y: $0.acceleration.y,
                                                z: $0.acceleration.z) })
    }

    init(configuration: ReadConfiguration) throws {
        NSLog("WARNING: MotionFile has not implemented FileDocument.init(configuration)")
        self.motion = [MotionValue]()
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        var content: Data
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = JSONEncoder.DateEncodingStrategy.millisecondsSince1970
        encoder.dataEncodingStrategy = JSONEncoder.DataEncodingStrategy.base64
        do {
            content = try encoder.encode(self.motion)
        } catch {
            NSLog("ERROR: \(error)")
            content = "\(error)".data(using: .utf8)!
        }
        return FileWrapper(regularFileWithContents: content)
    }

    /// Create a file name representing a file document given a date.
    static func defaultFileName(start: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        // https://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"

        return formatter.string(from: start)
    }
}
