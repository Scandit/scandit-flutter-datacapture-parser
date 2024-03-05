/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.parser

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference
import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock

/** ScanditFlutterDataCaptureParserProxyPlugin. */
class ScanditFlutterDataCaptureParserProxyPlugin : FlutterPlugin, ActivityAware {

    companion object {
        @JvmStatic
        private val lock = ReentrantLock()

        @JvmStatic
        private var isPluginAttached = false
    }

    private var methodChannel: MethodChannel? = null

    private var scanditFlutterDataCaptureParserPlugin:
        ScanditFlutterDataCaptureParserMethodHandler? = null

    private var flutterPluginBinding: WeakReference<FlutterPluginBinding?> = WeakReference(null)

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        flutterPluginBinding = WeakReference(binding)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        flutterPluginBinding = WeakReference(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        onAttached()
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetached()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttached()
    }

    override fun onDetachedFromActivity() {
        onDetached()
    }

    private fun onAttached() {
        lock.withLock {
            if (isPluginAttached) return
            val flutterBinding = flutterPluginBinding.get() ?: return
            setupModule(flutterBinding)
            isPluginAttached = true
        }
    }

    private fun onDetached() {
        lock.withLock {
            val flutterBinding = flutterPluginBinding.get() ?: return
            disposeModule(flutterBinding)
            isPluginAttached = false
        }
    }

    private fun setupModule(binding: FlutterPluginBinding) {
        scanditFlutterDataCaptureParserPlugin = ScanditFlutterDataCaptureParserMethodHandler()
        scanditFlutterDataCaptureParserPlugin?.onAttachedToEngine(binding)
        methodChannel = MethodChannel(
            binding.binaryMessenger,
            "com.scandit.datacapture.parser.method/parser"
        ).also {
            it.setMethodCallHandler(scanditFlutterDataCaptureParserPlugin)
        }
    }

    private fun disposeModule(binding: FlutterPluginBinding) {
        scanditFlutterDataCaptureParserPlugin?.onDetachedFromEngine(binding)
        scanditFlutterDataCaptureParserPlugin = null
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
    }
}
