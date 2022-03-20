//
//  ExerciseUITests.swift
//  ExerciseUITests
//
//  Created by MUhammad Sadiq on 19/03/2022.
//

import XCTest
import Exercise

class LandingViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

//    func testCluster() {
//        app.launch()
//        let cluster = app.otherElements.matching(identifier: "cluster").element(boundBy: 0)
//        XCTAssertTrue(cluster.exists)
//    }
    
    func testAnnotationAndCallout() {
        app.launch()
        let annotation = app.otherElements.matching(identifier: "annotation").element(boundBy: 0)
        XCTAssertTrue(annotation.exists)
        annotation.tap()
        
        let callout = app.otherElements.matching(identifier: "callOutView").element(boundBy: 0)
        wait(for: callout, timeout: 2)
        XCTAssertTrue(callout.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCTestCase {
  /// Wait for element to appear
  func wait(for element: XCUIElement, timeout duration: TimeInterval) {
    let predicate = NSPredicate(format: "exists == true")
    let _ = expectation(for: predicate, evaluatedWith: element, handler: nil)

    waitForExpectations(timeout: duration + 0.5)
  }
}
