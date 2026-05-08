/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.parser;

import androidx.annotation.NonNull;

import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.DefaultServiceLocator;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;
import com.scandit.datacapture.frameworks.parser.ParserModule;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;

import java.util.concurrent.locks.ReentrantLock;

public class ScanditFlutterDataCaptureParserProxyPlugin implements FlutterPlugin, ActivityAware {
    private static final ReentrantLock lock = new ReentrantLock();

    private final ServiceLocator<FrameworkModule> serviceLocator = DefaultServiceLocator.getInstance();

    private MethodChannel methodChannel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        setupModules(binding);
        setupMethodChannels(binding);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        disposeMethodChannels();
        disposeModules();
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        // NOOP
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        // NOOP
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        // NOOP
    }

    @Override
    public void onDetachedFromActivity() {
        // NOOP
    }

    private void setupMethodChannels(@NonNull FlutterPluginBinding binding) {
        ParserMethodHandler methodHandler = new ParserMethodHandler(serviceLocator);
        methodChannel = new MethodChannel(
                binding.getBinaryMessenger(),
                "com.scandit.datacapture.parser/method_channel"
        );
        methodChannel.setMethodCallHandler(methodHandler);
    }

    private void disposeMethodChannels() {
        if (methodChannel != null) {
            methodChannel.setMethodCallHandler(null);
            methodChannel = null;
        }
    }

    private void setupModules(@NonNull FlutterPluginBinding binding) {
        lock.lock();
        try {
            ParserModule parserModule = (ParserModule) serviceLocator.resolve(ParserModule.class.getName());
            if (parserModule != null) return;

            parserModule = new ParserModule();
            parserModule.onCreate(binding.getApplicationContext());
            serviceLocator.register(parserModule);
        } finally {
            lock.unlock();
        }
    }

    private void disposeModules() {
        lock.lock();
        try {
            ParserModule parserModule = (ParserModule) serviceLocator.remove(ParserModule.class.getName());
            if (parserModule != null) {
                parserModule.onDestroy();
            }
        } finally {
            lock.unlock();
        }
    }
}
