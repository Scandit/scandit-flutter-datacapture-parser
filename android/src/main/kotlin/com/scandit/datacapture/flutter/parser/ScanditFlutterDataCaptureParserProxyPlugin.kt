/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.parser

import com.scandit.datacapture.frameworks.core.locator.DefaultServiceLocator
import com.scandit.datacapture.frameworks.parser.ParserModule
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

    private var methodHandler:
        ParserMethodHandler? = null

    private var flutterPluginBinding: WeakReference<FlutterPluginBinding?> = WeakReference(null)

    private val serviceLocator = DefaultServiceLocator.getInstance()

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        flutterPluginBinding = WeakReference(binding)
        onAttached()
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        flutterPluginBinding = WeakReference(null)
        onDetached()
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
            if (isPluginAttached) {
                disposeModule()
            }
            val flutterBinding = flutterPluginBinding.get() ?: return
            setupModule(flutterBinding)
            isPluginAttached = true
        }
    }

    private fun onDetached() {
        lock.withLock {
            disposeModule()
            isPluginAttached = false
        }
    }

    private fun setupModule(binding: FlutterPluginBinding) {
        val module = ParserModule().also {
            it.onCreate(binding.applicationContext)
        }
        methodHandler = ParserMethodHandler(module)
        methodChannel = MethodChannel(
            binding.binaryMessenger,
            "com.scandit.datacapture.parser/method_channel"
        ).also {
            it.setMethodCallHandler(methodHandler)
        }
        serviceLocator.register(module)
    }

    private fun disposeModule() {
        serviceLocator.remove(ParserModule::class.java.name)?.onDestroy()
        methodHandler = null
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
    }
}
