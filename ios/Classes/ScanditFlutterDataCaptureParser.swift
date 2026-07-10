/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import Flutter
import scandit_flutter_datacapture_core
import ScanditFrameworksParser

@objc
public class ScanditFlutterDataCaptureParser: NSObject, FlutterPlugin {
    private let methodChannel: FlutterMethodChannel
    private let parserModule: ParserModule

    init(methodChannel: FlutterMethodChannel, parserModule: ParserModule) {
        self.methodChannel = methodChannel
        self.parserModule = parserModule
    }

    @objc
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "com.scandit.datacapture.parser/method_channel",
                                                 binaryMessenger: registrar.messenger())
        let parserModule = ParserModule()
        let plugin = ScanditFlutterDataCaptureParser(methodChannel: methodChannel,
                                                     parserModule: parserModule)
        let methodHandler = ParserMethodCallHandler(parserModule: parserModule)
        parserModule.didStart()
        methodChannel.setMethodCallHandler(methodHandler.handleMethodCall(_:result:))
        registrar.publish(plugin)
    }

    @objc
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        parserModule.didStop()
        methodChannel.setMethodCallHandler(nil)
    }
}
