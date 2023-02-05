import SwiftUI
import CoreMotion

/// Textual summary of an acceleration in each dimension.
struct AccelerationView: View {
    /// Model providing acceleration data.
    let acceleration: Motion?
    private var description: String {
        get {
            if let acceleration = acceleration?.acceleration {
                return String(format: "%.2f, %.2f, %.2f", acceleration.x, acceleration.y, acceleration.z)
            } else {
                return "nil, nil, nil"
            }
        }
    }

    var body: some View {
        HStack {
            Text(description)
        }
    }
}

struct AccelerationView_Previews: PreviewProvider {
    static var previews: some View {
        AccelerationView(acceleration: Motion(timestamp: 42.1, acceleration: CMAcceleration(x: 1.2, y: 3.4, z: 5.6)))
        AccelerationView(acceleration: nil)
    }
}
