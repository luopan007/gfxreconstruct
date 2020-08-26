REM # Delete the global setting that enables layers
adb shell settings delete global enable_gpu_debug_layers

REM # Delete the global setting that selects target application
adb shell settings delete global gpu_debug_app

REM # Delete the global setting that specifies layer list
adb shell settings delete global gpu_debug_layers

REM # Delete the global setting that specifies layer packages
adb shell settings delete global gpu_debug_layer_app

REM # Disable to load layers for all applications, including native executables
adb shell setprop debug.vulkan.layers  '""'
adb shell setprop debug.vulkan.layer.1 '""'
adb shell setprop debug.vulkan.layer.2 '""'
adb shell setprop debug.vulkan.layer.3 '""'
adb shell setprop debug.vulkan.layer.4 '""'
adb shell setprop debug.vulkan.layer.5 '""'
adb shell setprop debug.vulkan.layer.6 '""'
adb shell setprop debug.vulkan.layer.7 '""'
adb shell setprop debug.vulkan.layer.8 '""'

adb shell rm -rf /data/local/debug/vulkan/libVkLayer*

echo "Clean Enviroment Path Finished."

REM # gradlew clean assembledebug

setlocal EnableDelayedExpansion
set curdir=%~dp0
cd /d %~dp0

set gfxrreconstruct_lib32=%curdir%layer\build\intermediates\library_and_local_jars_jni\debug\armeabi-v7a\
set gfxrreconstruct_lib64=%curdir%layer\build\intermediates\library_and_local_jars_jni\debug\arm64-v8a\

set data_debug_libs=/data/local/debug/vulkan/

echo %gfxrreconstruct_lib32%
echo %gfxrreconstruct_lib64%
echo %data_debug_libs%

adb remount 
adb shell setenforce 0

adb push %gfxrreconstruct_lib32%libVkLayer_gfxreconstruct.so %data_debug_libs%libVkLayer_gfxreconstruct32.so
adb push %gfxrreconstruct_lib64%libVkLayer_gfxreconstruct.so %data_debug_libs%libVkLayer_gfxreconstruct64.so

REM # Enabling the Layer with ADB
adb shell "setprop debug.vulkan.layers 'VK_LAYER_LUNARG_gfxreconstruct'"

REM # Set the log_level to "warning"
adb shell "setprop debug.gfxrecon.log_level 'warning'"

REM # Enable Settings File
adb shell "setprop debug.gfxrecon.settings_path /sdcard/vk_layer_settings.txt"

pause
