/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.parser

import com.scandit.datacapture.flutter.core.utils.FlutterResult
import com.scandit.datacapture.frameworks.parser.ParserModule
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ParserMethodHandler(
    private val parserModule: ParserModule
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_PARSE_STRING -> parserModule.parseString(
                call.arguments as String,
                FlutterResult(result)
            )

            METHOD_PARSE_RAW_DATA -> parserModule.parseRawData(
                call.arguments as String,
                FlutterResult(result)
            )

            METHOD_CREATE_UPDATE_NATIVE_INSTANCE -> parserModule.createOrUpdateParser(
                call.arguments as String,
                FlutterResult(result)
            )

            METHOD_DISPOSE_PARSER -> parserModule.disposeParser(
                call.arguments as String,
                FlutterResult(result)
            )

            else -> result.notImplemented()
        }
    }

    companion object {
        private const val METHOD_PARSE_STRING = "parseString"
        private const val METHOD_PARSE_RAW_DATA = "parseRawData"
        private const val METHOD_CREATE_UPDATE_NATIVE_INSTANCE = "createUpdateNativeInstance"
        private const val METHOD_DISPOSE_PARSER = "disposeParser"
    }
}
