/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.parser;

import androidx.annotation.NonNull;

import com.scandit.datacapture.flutter.core.utils.FlutterMethodCall;
import com.scandit.datacapture.flutter.core.utils.FlutterResult;
import com.scandit.datacapture.frameworks.core.CoreModule;
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
        if (call.method.equals("executeParser")) {
            CoreModule coreModule = (CoreModule) getModule(CoreModule.class.getSimpleName());
            if (coreModule == null) {
                result.error("-1", "Unable to retrieve the CoreModule from the locator.", null);
                return;
            }

            boolean executionResult = coreModule.execute(new FlutterMethodCall(call), new FlutterResult(result), getSharedModule());
            if (!executionResult) {
                String methodName = call.argument("methodName");
                if (methodName == null) {
                    methodName = "unknown";
                }

                result.error("METHOD_NOT_FOUND", "Unknown Core method: " + methodName, null);
            }
            return;
        }
        result.notImplemented();
    }

    private volatile ParserModule sharedModuleInstance;

    private ParserModule getSharedModule() {
        if (sharedModuleInstance == null) {
            synchronized (this) {
                if (sharedModuleInstance == null) {
                    sharedModuleInstance = (ParserModule) this.serviceLocator.resolve(ParserModule.class.getSimpleName());
                }
            }
        }
        return sharedModuleInstance;
    }

    private FrameworkModule getModule(String moduleName) {
        return this.serviceLocator.resolve(moduleName);
    }
}
