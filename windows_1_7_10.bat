@echo off
color 4
set GRAAL_SETUP_FILE=%USERPROFILE%\.graallcsetup.txt
::set "websocket=websocket.lunarclientprod.com"
::set "localh=127.0.0.1"
setlocal enabledelayedexpansion

if exist "%GRAAL_SETUP_FILE%" (
    echo JRE is already installed, skipping installation
) else (
    echo downloading GraalVM zip file
    powershell -command "& { Invoke-WebRequest -Uri 'https://download.oracle.com/graalvm/17/latest/graalvm-jdk-17_windows-x64_bin.zip' -OutFile '%USERPROFILE%\graalvm.zip' }"

    echo extracting files to user directory and rename folder
    powershell -command "& { Expand-Archive -Path '%USERPROFILE%\graalvm.zip' -DestinationPath '%USERPROFILE%\' }"
    powershell -command "& { Rename-Item -Path '%USERPROFILE%\graalvm-ce-java17-22.3.1' -NewName 'graal' }"

    echo setting environment variable for GraalVM location
    setx GRAALVM_HOME "%USERPROFILE%\graal"

    echo creating setup file to indicate that JRE is installed
    echo JRE is installed > "%GRAAL_SETUP_FILE%"
)
echo Launching Lunarclient
cd "%USERPROFILE%\.lunarclient\offline\multiver\"
"%USERPROFILE%\graal\bin\java" ^
    --add-modules jdk.naming.dns ^
    --add-exports jdk.naming.dns/com.sun.jndi.dns=java.naming ^
    -Djna.boot.library.path=natives ^
    -Dlog4j2.formatMsgNoLookups=true ^
    --add-opens java.base/java.io=ALL-UNNAMED ^
    -Xmx3G -Xms3G -Xmn1G ^
    -Djava.library.path=natives -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+AlwaysActAsServerClassMachine -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseNUMA -XX:AllocatePrefetchStyle=3 ^
    -XX:NmethodSweepActivity=1 -XX:ReservedCodeCacheSize=400M -XX:NonNMethodCodeHeapSize=12M -XX:ProfiledCodeHeapSize=194M -XX:NonProfiledCodeHeapSize=194M -XX:-DontCompileHugeMethods ^
    -XX:+PerfDisableSharedMem -XX:+UseFastUnorderedTimeStamps -XX:+UseCriticalJavaThreadPriority -XX:+EagerJVMCI -XX:+UseG1GC -XX:MaxGCPauseMillis=37 -XX:+PerfDisableSharedMem ^
    -XX:G1HeapRegionSize=16M -XX:G1NewSizePercent=23 -XX:G1ReservePercent=20 -XX:SurvivorRatio=32 -XX:G1MixedGCCountTarget=3 -XX:G1HeapWastePercent=20 -XX:InitiatingHeapOccupancyPercent=10 ^
    -XX:G1RSetUpdatingPauseTimePercent=0 -XX:MaxTenuringThreshold=1 -XX:G1SATBBufferEnqueueingThresholdPercent=30 -XX:G1ConcMarkStepDurationMillis=5.0 -XX:G1ConcRSHotCardLimit=16 -XX:G1ConcRefinementServiceIntervalMillis=150 -XX:GCTimeRatio=99 ^
    -XX:+UseStringDeduplication -XX:+UseCompressedOops -XX:+UseCompressedClassPointers -XX:CompileThreshold=10000 -XX:InlineSmallCode=2000 -XX:+OptimizeStringConcat -XX:+UseBiasedLocking -XX:+UseLargePages -XX:+UseAdaptiveSizePolicy ^
    -XX:+UseTLAB -XX:TLABSize=256k -XX:PretenureSizeThreshold=512k -XX:MaxInlineSize=300 -XX:LoopUnrollLimit=60 -XX:+TieredCompilation ^
    -cp "v1_7-0.1.0-SNAPSHOT-all.jar;lunar-lang.jar;lunar.jar;optifine-0.1.0-SNAPSHOT-all.jar;common-0.1.0-SNAPSHOT-all.jar;genesis-0.1.0-SNAPSHOT-all.jar;OptiFine_1.7.10_HD_U_E7" ^
    com.moonsworth.lunar.genesis.Genesis ^
    --version 1.7.10 ^
    --accessToken 0 ^
    --assetIndex 1.7.10 ^
    --launcherVersion 3.1.3 ^
    --userProperties {} ^
    --gameDir "%USERPROFILE%\.minecraft" ^
    --texturesDir "%USERPROFILE%\.lunarclient\textures" ^
    --width 1280 ^
    --height 720 ^
    --workingDirectory . ^
    --classpathDir . ^
    --ichorClassPath "v1_7-0.1.0-SNAPSHOT-all.jar;lunar-lang.jar;lunar.jar;optifine-0.1.0-SNAPSHOT-all.jar;common-0.1.0-SNAPSHOT-all.jar"
    --ichorExternalFiles OptiFine_v1_7.jar
    findstr /v "%localh% %websocket%" %SystemRoot%\System32\drivers\etc\hosts > %SystemRoot%\System32\drivers\etc\hosts_temp
    move /y %SystemRoot%\System32\drivers\etc\hosts_temp %SystemRoot%\System32\drivers\etc\hosts
pause
