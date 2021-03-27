@echo off

@REM Delete the global setting that enables layers
adb shell settings delete global enable_gpu_debug_layers

@REM Delete the global setting that selects target application
adb shell settings delete global gpu_debug_app

@REM Delete the global setting that specifies layer list
adb shell settings delete global gpu_debug_layers

@REM Delete the global setting that specifies layer packages
adb shell settings delete global gpu_debug_layer_app

adb shell setprop debug.gfxrecon.capture_file ''
adb shell setprop debug.gfxrecon.capture_file_timestamp ''
