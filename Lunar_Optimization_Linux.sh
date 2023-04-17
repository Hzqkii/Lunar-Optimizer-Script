#!/bin/bash

GRAAL_SETUP_FILE="$HOME/.graallcsetup.txt"

if [ -f "$GRAAL_SETUP_FILE" ]; then
    echo "JRE is already installed, skipping installation"
else
    echo "downloading GraalVM zip file"
    wget -q "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.3.1/graalvm-ce-java17-linux-amd64-22.3.1.tar.gz" -P "$HOME"

    echo "extracting files to user directory and rename folder"
    tar -xzf "$HOME/graalvm-ce-java17-linux-amd64-22.3.1.tar.gz" -C "$HOME"
    mv "$HOME/graalvm-ce-java17-22.3.1" "$HOME/graal"

    echo "setting environment variable for GraalVM location"
    echo "export GRAALVM_HOME=$HOME/graal" >> ~/.bashrc
    source ~/.bashrc

    echo "creating setup file to indicate that JRE is installed"
    echo "JRE is installed" > "$GRAAL_SETUP_FILE"
fi

echo Downloading working version of lwjgl64
wget -q "https://raw.githubusercontent.com/Sensssssss/Lunar-Scripts/main/Linux/prerequisites/liblwjgl64.so" -P "$HOME"
echo "Moving and replacing the lwjgl64.so file"
mv -f "$HOME/liblwjgl64.so" "$HOME/.lunarclient/offline/multiver/natives/liblwjgl64.so"

echo "Launching Lunarclient"
cd "$HOME/.lunarclient/offline/multiver/"
mangohud \
gamemoderun \
"$HOME/graal/bin/java" \
    --add-modules jdk.naming.dns \
    --add-exports jdk.naming.dns/com.sun.jndi.dns=java.naming \
    -Djna.boot.library.path=natives \
    -Djava.library.path=natives \
    -Dlog4j2.formatMsgNoLookups=true \
    --add-opens java.base/java.io=ALL-UNNAMED \
    -Xmx3G -Xms3G -Xmn1G -javaagent:/home/hzqki/Downloads/solar-engine.jar=/home/hzqki/Downloads/config.json \
    -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+AlwaysActAsServerClassMachine -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseNUMA -XX:AllocatePrefetchStyle=3 \
    -XX:NmethodSweepActivity=1 -XX:ReservedCodeCacheSize=400M -XX:NonNMethodCodeHeapSize=12M -XX:ProfiledCodeHeapSize=194M -XX:NonProfiledCodeHeapSize=194M -XX:-DontCompileHugeMethods \
    -XX:+PerfDisableSharedMem -XX:+UseFastUnorderedTimeStamps -XX:+UseCriticalJavaThreadPriority -XX:+EagerJVMCI -XX:+UseG1GC -XX:MaxGCPauseMillis=37 -XX:+PerfDisableSharedMem \
    -XX:G1HeapRegionSize=16M -XX:G1NewSizePercent=23 -XX:G1ReservePercent=20 -XX:SurvivorRatio=32 -XX:G1MixedGCCountTarget=3 -XX:G1HeapWastePercent=20 -XX:InitiatingHeapOccupancyPercent=10 \
    -XX:G1RSetUpdatingPauseTimePercent=0 -XX:MaxTenuringThreshold=1 -XX:G1SATBBufferEnqueueingThresholdPercent=30 -XX:G1ConcMarkStepDurationMillis=5.0 -XX:G1ConcRSHotCardLimit=16 -XX:G1ConcRefinementServiceIntervalMillis=150 -XX:GCTimeRatio=99 \
    -cp "v1_7-0.1.0-SNAPSHOT-all.jar:lunar-lang.jar:lunar.jar:optifine-0.1.0-SNAPSHOT-all.jar:common-0.1.0-SNAPSHOT-all.jar:genesis-0.1.0-SNAPSHOT-all.jar:OptiFine_1.7.10_HD_U_E7" \
    com.moonsworth.lunar.genesis.Genesis \
    --version 1.7.10 \
    --accessToken 0 \
    --assetIndex 1.7.10 \
    --userProperties {} \
    --gameDir "$HOME/.minecraft" \
    --texturesDir "$HOME/.lunarclient/textures" \
    --width 1280 \
    --height 720 \
    --workingDirectory . \
    --classpathDir . \
    --ichorClassPath "v1_7-0.1.0-SNAPSHOT-all.jar;lunar-lang.jar;lunar.jar;optifine-0.1.0-SNAPSHOT-all.jar;common-0.1.0-SNAPSHOT-all.jar"
