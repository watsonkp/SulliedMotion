import SwiftUI

/// A type of object providing motion data, statistics, and controls.
public protocol MotionProtocol: ObservableObject {
    /// Historical motion data.
    var history: [Motion] { get }
    /// Most recent motion value.
    var latest: Motion? { get }
    /// Toggle the production of motion data on or off.
    func toggle() -> Void
    /// Number of motion values received.
    var count: Int { get }
    /// Minimum motion values for each dimension.
    var minimum: (Double, Double, Double)? { get }
    /// Maximum motion values for each dimension.
    var maximum: (Double, Double, Double)? { get }
    /// Current status of motion data production.
    var recording: Bool { get }
}
