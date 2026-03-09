/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksCore
import ScanditFrameworksParser

class ParserMethodCallHandler {
    private enum FunctioNames {
        static let parseString = "parseString"
        static let parseRawData = "parseRawData"
        static let createUpdateNativeInstance = "createUpdateNativeInstance"
        static let disposeParser = "disposeParser"
    }
    private let parserModule: ParserModule

    init(parserModule: ParserModule) {
        self.parserModule = parserModule
    }

    @objc
    func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case FunctioNames.parseString:
            guard let args = call.arguments as? String else {
                result(FlutterError(code: "-1", message: "Invalid argument", details: nil))
                return
            }
            parserModule.parse(parsingData: args, result: .create(result))
        case FunctioNames.parseRawData:
            guard let args = call.arguments as? String else {
                result(FlutterError(code: "-1", message: "Invalid argument", details: nil))
                return
            }
            parserModule.parseRawData(parsingData: args, result: .create(result))
        case FunctioNames.createUpdateNativeInstance:
            guard let args = call.arguments as? String else {
                result(FlutterError(code: "-1", message: "Invalid argument", details: nil))
                return
            }
            parserModule.createOrUpdateParser(parserJson: args, result: .create(result))
        case FunctioNames.disposeParser:
            guard let args = call.arguments as? String else {
                result(FlutterError(code: "-1", message: "Invalid argument", details: nil))
                return
            }
            parserModule.disposeParser(parserId: args, result: .create(result))
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
