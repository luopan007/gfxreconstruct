@echo off
setlocal EnableDelayedExpansion
adb remount
adb shell setenforce 0

@REM 获取目标APK包名
set targetApk=%1

@REM 1. 安装携带抓取层的库文件的APK，该APK同时也有回放的功能
@REM python scripts\gfxrecon.py install-apk tools\replay\build\outputs\apk\debug\replay-debug.apk

@REM 2. 设置抓取层的参数
@REM 启动Android的调试层功能
adb shell "settings put global enable_gpu_debug_layers 1"

@REM 指定即将抓取的目标APK，按照包名指定
adb shell "settings put global gpu_debug_app %targetApk%"

@REM 设置抓取层的名字
adb shell "settings put global gpu_debug_layers VK_LAYER_LUNARG_gfxreconstruct"

@REM 设置专抓取层的库文件的搜索位置
adb shell "settings put global gpu_debug_layer_app com.lunarg.gfxreconstruct.replay"

@REM 显示以上设置参数
adb shell "settings list global |grep gpu"

@REM 3. 设置gfxr文件的保存的位置（涉及SD卡的读写问题，所以不要修改这个地方）
@REM 查询手机的SDK版本，保存到sdkVersion
for /F %%i in ('adb shell getprop ro.build.version.sdk') do (set sdkVersion=%%i)

@REM 设置gfxr文件保存的位置，在对应抓取APK的gfx目录下
if "%sdkVersion%" GEQ 30 (
  adb shell "setprop debug.gfxrecon.capture_file /sdcard/Android/media/%targetApk%/files/gfx/gfxrecon_capture.gfxr"
  adb shell "mkdir -p /sdcard/Android/media/%targetApk%/files/gfx"
) else (
  adb shell "setprop debug.gfxrecon.capture_file /sdcard/Android/data/%targetApk%/files/gfx/gfxrecon_capture.gfxr"
  adb shell "mkdir -p /sdcard/Android/data/%targetApk%/files/gfx"
)
@REM 去掉文件名的时间戳
@REM adb shell setprop debug.gfxrecon.capture_file_timestamp false

@REM 显示以上设置参数
adb shell "getprop |grep gfxrecon"

@REM 4. 启动需要抓取目标APK
echo 1. Start the Target App: %targetApk%
echo 2. Capture the key frame
echo 3. Exit the target App
echo 4. We must do three things on the above, so we can enter and continue

pause

@REM 5. 保存gfxr文件
if "%sdkVersion%" GEQ 30 (
  adb pull /sdcard/Android/media/%targetApk%/files/gfx .
) else (
  adb pull /sdcard/Android/data/%targetApk%/files/gfx .
)

