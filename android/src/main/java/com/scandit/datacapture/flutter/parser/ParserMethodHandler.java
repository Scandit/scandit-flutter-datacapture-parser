/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.parser;

import androidx.annotation.NonNull;

import com.scandit.datacapture.flutter.core.utils.FlutterResult;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;
import com.scandit.datacapture.frameworks.parser.ParserModule;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ParserMethodHandler implements MethodChannel.MethodCallHandler {

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public ParserMethodHandler(ServiceLocator<FrameworkModule> serviceLocator) {
        this.serviceLocator = serviceLocator;
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "parseString":
                assert call.arguments() != null;
                getSharedModule().parseString(call.arguments(), new FlutterResult(result));
                break;
            case "parseRawData":
                assert call.arguments() != null;
                getSharedModule().parseRawData(call.arguments(), new FlutterResult(result));
                break;
            case "createUpdateNativeInstance":
                assert call.arguments() != null;
                getSharedModule().createOrUpdateParser(call.arguments(), new FlutterResult(result));
                break;
            case "disposeParser":
                assert call.arguments() != null;
                getSharedModule().disposeParser(call.arguments(), new FlutterResult(result));
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private volatile ParserModule sharedModuleInstance;

    private ParserModule getSharedModule() {
        if (sharedModuleInstance == null) {
            synchronized (this) {
                if (sharedModuleInstance == null) {
                    sharedModuleInstance = (ParserModule) this.serviceLocator.resolve(ParserModule.class.getName());
                }
            }
        }
        return sharedModuleInstance;
    }
}
