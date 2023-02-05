import XCTest
@testable import SulliedMotion
import CoreMotion

final class SulliedMotionTests: XCTestCase {
    func testMagnitude() throws {
        XCTAssertEqual(SulliedMotion.magnitude(CMAcceleration(x: 1.0, y: 1.0, z: 1.0)), sqrt(3.0))
        XCTAssertEqual(SulliedMotion.magnitude(CMAcceleration(x: -1.0, y: -1.0, z: -1.0)), sqrt(3.0))
        XCTAssertEqual(SulliedMotion.magnitude(CMAcceleration(x: -1.0, y: 1.0, z: -1.0)), sqrt(3.0))
        XCTAssertEqual(SulliedMotion.magnitude(CMAcceleration(x: 1.0, y: 2.0, z: 3.0)), sqrt(14.0))
        XCTAssertEqual(SulliedMotion.magnitude(CMAcceleration(x: 3.0, y: 2.0, z: 1.0)), sqrt(14.0))
        XCTAssertEqual(SulliedMotion.magnitude(CMAcceleration(x: -1.0, y: -2.0, z: -3.0)), sqrt(14.0))
        XCTAssertEqual(SulliedMotion.magnitude(CMAcceleration(x: -3.0, y: -2.0, z: -1.0)), sqrt(14.0))
    }
}
