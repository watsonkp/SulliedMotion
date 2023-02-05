import Foundation
import Combine
import CoreMotion

/// A `MotionProtocol` emitting motion data, statistics, and controls using a timer publisher.
public final class DesignTimeMotionModel: MotionProtocol {
    private var cancellable: AnyCancellable? = nil
    @Published public var history = [Motion]()
    @Published public var minimum: (Double, Double, Double)? = nil
    @Published public var maximum: (Double, Double, Double)? = nil
    @Published public var recording = false

    public var latest: Motion? {
        get {
            history.last
        }
    }

    public var count: Int {
        get {
            history.count
        }
    }

    public func toggle() {
        if self.cancellable == nil {
            reset()
            let start = Date.now
            self.cancellable = Timer.TimerPublisher(interval: 0.01, runLoop: RunLoop.main, mode: RunLoop.Mode.default)
                .autoconnect()
                .map( { Motion(timestamp: $0.timeIntervalSince(start),
                               acceleration: CMAcceleration(x: 2 * sin((2.0 * Double.pi) * $0.timeIntervalSince(start) / 2.0),
                                                            y: 2 * cos((2.0 * Double.pi) * $0.timeIntervalSince(start) / 4.0),
                                                            z: 1 * sin((2.0 * Double.pi) * $0.timeIntervalSince(start) / 8.0))) } )
                .sink(receiveValue: {
                    self.history.append($0)

                    // Update minimum values
                    guard let minimum = self.minimum else {
                        self.minimum = ($0.acceleration.x, $0.acceleration.y, $0.acceleration.z)
                        return
                    }
                    self.minimum = ($0.acceleration.x < minimum.0 ? $0.acceleration.x : minimum.0,
                                    $0.acceleration.y < minimum.1 ? $0.acceleration.y : minimum.1,
                                    $0.acceleration.z < minimum.2 ? $0.acceleration.z : minimum.2)

                    // Update maximum values
                    guard let maximum = self.maximum else {
                        self.maximum = ($0.acceleration.x, $0.acceleration.y, $0.acceleration.z)
                        return
                    }
                    self.maximum = ($0.acceleration.x > maximum.0 ? $0.acceleration.x : maximum.0,
                                    $0.acceleration.y > maximum.1 ? $0.acceleration.y : maximum.1,
                                    $0.acceleration.z > maximum.2 ? $0.acceleration.z : maximum.2)
                })
            self.recording = true
        } else {
            self.cancellable?.cancel()
            self.cancellable = nil
            self.recording = false
        }
    }

    /// Creates a `MotionProtocol`.
    public init() { }

    /// Clear motion data and derived statistics.
    private func reset() {
        self.history = [Motion]()
        self.minimum = nil
        self.maximum = nil
    }
}
