import SwiftUI
import CoreMotion

/// A `MotionProtocol` emitting motion data, statistics, and controls using the CoreMotion framework.
public class MotionModel: MotionProtocol {
    @Published public var history = [Motion]()
    @Published public var latest: Motion? = nil
    let manager: CMMotionManager
    let queue: OperationQueue = OperationQueue()
    var start: TimeInterval? = nil
    public var minimum: (Double, Double, Double)? = nil
    public var maximum: (Double, Double, Double)? = nil
    @Published public var recording: Bool = false

    public var count: Int {
        get {
            history.count
        }
    }

    /// Creates a `MotionProtocol` based on the given instance of the CoreMotion motion manager.
    ///  - Parameters:
    ///  - manager: The single instance created by the consuming application.
    public init(_ manager: CMMotionManager) {
        self.manager = manager
    }

    public func toggle() {
        // Start motion updates only the service is available.
        if !manager.isDeviceMotionAvailable {
            NSLog("ERROR: Device motion is not available.")
            return
        }

        if manager.isDeviceMotionActive {
            NSLog("DEBUG: Stopping device motion updates.")
            manager.stopDeviceMotionUpdates()
            self.recording = false
        } else {
            NSLog("DEBUG: Starting device motion updates.")
            self.queue.name = "DeviceMotion"

            // Reset model to default values
            reset()
            manager.deviceMotionUpdateInterval = TimeInterval(floatLiteral: 1.0 / 60.0)
            manager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: self.queue) { (motion: CMDeviceMotion?, error: Error?) -> Void in
                guard let validMotion = motion else {
                    return
                }
                if self.start == nil {
                    self.start = validMotion.timestamp
                }
                DispatchQueue.main.async {
                    guard let start = self.start else {
                        NSLog("Error: Expected DeviceMotion.start is nil.")
                        return
                    }
                    let nextMotion = Motion(timestamp: validMotion.timestamp - start, acceleration: validMotion.userAcceleration)
                    self.history.append(nextMotion)
                    guard let previous = self.latest else {
                        self.latest = nextMotion
                        return
                    }
                    if validMotion.timestamp > previous.timestamp {
                        self.latest = nextMotion
                    }

                    // Update minimum values
                    guard let minimum = self.minimum else {
                        self.minimum = (nextMotion.acceleration.x, nextMotion.acceleration.y, nextMotion.acceleration.z)
                        return
                    }
                    self.minimum = (nextMotion.acceleration.x < minimum.0 ? nextMotion.acceleration.x : minimum.0,
                                    nextMotion.acceleration.y < minimum.1 ? nextMotion.acceleration.y : minimum.1,
                                    nextMotion.acceleration.z < minimum.2 ? nextMotion.acceleration.z : minimum.2)


                    // Update maximum values
                    guard let maximum = self.maximum else {
                        self.maximum = (nextMotion.acceleration.x, nextMotion.acceleration.y, nextMotion.acceleration.z)
                        return
                    }
                    self.maximum = (nextMotion.acceleration.x > maximum.0 ? nextMotion.acceleration.x : maximum.0,
                                    nextMotion.acceleration.y > maximum.1 ? nextMotion.acceleration.y : maximum.1,
                                    nextMotion.acceleration.z > maximum.2 ? nextMotion.acceleration.z : maximum.2)
                }
            }
            self.recording = true
        }
    }

    /// Clear motion data and derived statistics.
    private func reset() {
        self.history = [Motion]()
        self.start = nil
        self.maximum = nil
        self.minimum = nil
    }
}
