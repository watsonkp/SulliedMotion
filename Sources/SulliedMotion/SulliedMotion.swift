import Combine
import CoreMotion

struct SulliedMotion {
    /// Calculate the magnitude of the provided acceleration vector.
    static func magnitude(_ acceleration: CMAcceleration) -> Double {
        sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2))
    }
}
