/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.parser;

import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;

import com.scandit.datacapture.flutter.core.BaseFlutterPlugin;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;
import com.scandit.datacapture.frameworks.parser.ParserModule;

import java.util.concurrent.atomic.AtomicInteger;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;

public class ScanditFlutterDataCaptureParserProxyPlugin extends BaseFlutterPlugin implements FlutterPlugin {

    private static final AtomicInteger activePluginInstances = new AtomicInteger(0);

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        activePluginInstances.incrementAndGet();
        super.onAttachedToEngine(binding);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        activePluginInstances.decrementAndGet();
        super.onDetachedFromEngine(binding);
    }

    @Override
    protected int getActivePluginInstanceCount() {
        return activePluginInstances.get();
    }

    @Override
    protected void setupMethodChannels(@NonNull FlutterPluginBinding binding, ServiceLocator<FrameworkModule> serviceLocator) {
        ParserMethodHandler methodHandler = new ParserMethodHandler(serviceLocator);
        MethodChannel channel = new MethodChannel(
                binding.getBinaryMessenger(),
                "com.scandit.datacapture.parser/method_channel"
        );
        channel.setMethodCallHandler(methodHandler);
        registerChannel(channel);
    }

    @Override
    protected void setupModules(@NonNull FlutterPluginBinding binding) {
        ParserModule parserModule = resolveModule(ParserModule.class);
        if (parserModule != null) return;

        parserModule = new ParserModule();
        parserModule.onCreate(binding.getApplicationContext());
        registerModule(parserModule);
    }

    @VisibleForTesting
    public static void resetActiveInstances() {
        activePluginInstances.set(0);
    }
}
