//
//  ImageLoaderTestCase.swift
//  ImageLoaderTests
//
//  Created by Hirohisa Kawasaki on 10/16/14.
//  Copyright © 2014 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import XCTest
@testable import ImageLoader

extension URLSessionTask.State {

    func toString() -> String {
        switch self {
        case .running:
            return "Running"
        case .suspended:
            return "Suspended"
        case .canceling:
            return "Canceling"
        case .completed:
            return "Completed"
        }
    }
}

class ImageLoaderTestCase: XCTestCase {

    func stub() {
        URLSessionConfiguration.swizzleDefaultToMock()
    }

    func sleep(_ duration: TimeInterval = 0.01) {
        RunLoop.main.run(until: Date(timeIntervalSinceNow: duration))
    }
}

public extension URLSessionConfiguration {

    public class func swizzleDefaultToMock() {
        let defaultSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.default))
        let swizzledDefaultSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.mock))
        method_exchangeImplementations(defaultSessionConfiguration!, swizzledDefaultSessionConfiguration!)
    }

    @objc private dynamic class var mock: URLSessionConfiguration {
        let configuration = self.mock
        configuration.protocolClasses?.insert(URLProtocolMock.self, at: 0)
        URLProtocol.registerClass(URLProtocolMock.self)
        return configuration
    }
}

public class URLProtocolMock: URLProtocol {

    override public class func canInit(with request:URLRequest) -> Bool {
        return true
    }

    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override public func startLoading() {
        self.client?.urlProtocol(self, didLoad: self.makeResponse())
        self.client?.urlProtocolDidFinishLoading(self)
//        self.client?.urlProtocol(self, didFailWithError: error)
    }

    override public func stopLoading() {}

    private func makeResponse() -> Data {
        var data = Data()
        if let path = request.url?.path , !path.isEmpty {
            switch path {
            case _ where path.hasSuffix("white"):
                let imagePath = Bundle(for: type(of: self)).path(forResource: "white", ofType: "png")!
                data = UIImagePNGRepresentation(UIImage(contentsOfFile: imagePath)!)!
            case _ where path.hasSuffix("black"):
                let imagePath = Bundle(for: type(of: self)).path(forResource: "black", ofType: "png")!
                data = UIImagePNGRepresentation(UIImage(contentsOfFile: imagePath)!)!
            default:
                break
            }
        }

        return data
    }
}
