/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.parser

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

/** ScanditFlutterDataCaptureParserProxyPlugin. */
class ScanditFlutterDataCaptureParserProxyPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    companion object {
        @Suppress("unused")
        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar) {
            val plugin = ScanditFlutterDataCaptureParserProxyPlugin()

            val channel = MethodChannel(
                registrar.messenger(),
                "com.scandit.datacapture.parser.method/parser"
            )

            plugin.scanditFlutterDataCaptureParserPlugin =
                ScanditFlutterDataCaptureParserMethodHandler()

            channel.setMethodCallHandler(plugin.scanditFlutterDataCaptureParserPlugin)
        }
    }

    private var methodChannel: MethodChannel? = null

    private var scanditFlutterDataCaptureParserPlugin:
        ScanditFlutterDataCaptureParserMethodHandler? = null

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        scanditFlutterDataCaptureParserPlugin = ScanditFlutterDataCaptureParserMethodHandler()
        scanditFlutterDataCaptureParserPlugin?.onAttachedToEngine(binding)
        methodChannel = MethodChannel(
            binding.binaryMessenger,
            "com.scandit.datacapture.parser.method/parser"
        ).also {
            it.setMethodCallHandler(scanditFlutterDataCaptureParserPlugin)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        scanditFlutterDataCaptureParserPlugin?.onDetachedFromEngine(binding)
        scanditFlutterDataCaptureParserPlugin = null
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        result.notImplemented()
    }
}
