/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksCore
import ScanditFrameworksParser
import scandit_flutter_datacapture_core

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
        case "executeParser":
            guard let args = call.params() else {
                result(FlutterError(code: "-1", message: "Missing arguments", details: nil))
                return
            }

            let coreModuleName = String(describing: CoreModule.self)
            guard let coreModule = DefaultServiceLocator.shared.resolve(clazzName: coreModuleName) as? CoreModule else {
                result(
                    FlutterError(
                        code: "-1",
                        message: "Unable to retrieve the CoreModule from the locator.",
                        details: nil
                    )
                )
                return
            }

            let flutterResult = FlutterFrameworkResult(reply: result)
            let handled = coreModule.execute(
                FlutterFrameworksMethodCall(call),
                result: flutterResult,
                module: self.parserModule
            )

            if !handled {
                let methodName = call.stringValue(for: "methodName", from: args) ?? "unknown"
                result(FlutterError(code: "-1", message: "Unknown Core method: \(methodName)", details: nil))
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
