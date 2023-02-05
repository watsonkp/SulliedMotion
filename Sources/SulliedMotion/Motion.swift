import CoreMotion

/// Encapsulated measurement of acceleration for a relative point in time.
public struct Motion {
    public let timestamp: TimeInterval
    public let acceleration: CMAcceleration
}
