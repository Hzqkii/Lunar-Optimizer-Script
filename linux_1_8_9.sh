#!/bin/bash

#LUNAR_BLOCKER="127.0.0.1 websocket.lunarclientprod.com" #block lunars websocket
GRAAL_SETUP_FILE="$HOME/.graallcsetup.txt"

if [ -f "$GRAAL_SETUP_FILE" ]; then
    echo "JRE is already installed, skipping installation"
else
    echo "downloading GraalVM zip file"
    wget -q "https://download.oracle.com/graalvm/17/latest/graalvm-jdk-17_linux-x64_bin.tar.gz" -P "$HOME" | zenity --progress --pulsate --title="Installing GraalVM" --text="Downloading JDK..." --auto-close

    echo "extracting files to user directory and rename folder"
    tar -xzf "$HOME/graalvm-ce-java17-linux-amd64-22.3.1.tar.gz" -C "$HOME" | zenity --progress --pulsate --title="Installing GraalVM" --text="Extracting files..." --auto-close
    mv "$HOME/graalvm-ce-java17-22.3.1" "$HOME/graal" | zenity --progress --pulsate --title="Installing GraalVM" --text="Renaming Files..." --auto-close

#    echo "Downloading Lunar Client Agents"
#    mkdir $HOME/.lunar-client-agents
#    wget -q "https://github.com/Nilsen84/lunar-client-agents/releases/download/v1.2.0/HitDelayFix.jar" -P "$HOME/.lunar-client-agents" | zenity --progress --pulsate --title="Installing Agents" --text="Downloading Agents" --auto-close

    echo "creating setup file to indicate that JRE is installed"
    echo "JRE is installed" > "$GRAAL_SETUP_FILE"
    
fi

echo Downloading working version of lwjgl64
wget -q "https://raw.githubusercontent.com/Sensssssss/Lunar-Scripts/main/Linux/prerequisites/liblwjgl64.so" -P "$HOME"
echo "Moving and replacing the lwjgl64.so file"
mv -f "$HOME/liblwjgl64.so" "$HOME/.lunarclient/offline/multiver/natives/liblwjgl64.so"

#password=$(zenity --password --title="Auth For Blocking Lunar") #elevation
#echo "$password" | sudo -S echo "Password entered." #test
#echo "$LUNAR_BLOCKER" | sudo tee -a /etc/hosts #add to hosts

echo "Launching Lunarclient"
cd "$HOME/.lunarclient/offline/multiver/"
#env OBS_VKCAPTURE=1 \
gamemoderun \
#env LD_PRELOAD="libpthread.so.0 libGL.so.1" __GL_THREADED_OPTIMIZATIONS=0 \
MANGOHUD_DLSYM=1 mangohud --dlsym \
"$HOME/graal/bin/java" \
    --add-modules jdk.naming.dns \
    --add-exports jdk.naming.dns/com.sun.jndi.dns=java.naming \
    -Djna.boot.library.path=natives \
    -Dlog4j2.formatMsgNoLookups=true \
    --add-opens java.base/java.io=ALL-UNNAMED \
    -Djava.library.path=natives \
    -Dlog4j2.formatMsgNoLookups=true \
    -Xmx3G -Xms3G -Xmn1G \
    -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+AlwaysActAsServerClassMachine -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseNUMA -XX:AllocatePrefetchStyle=3 \
    -XX:NmethodSweepActivity=1 -XX:ReservedCodeCacheSize=400M -XX:NonNMethodCodeHeapSize=12M -XX:ProfiledCodeHeapSize=194M -XX:NonProfiledCodeHeapSize=194M -XX:-DontCompileHugeMethods \
    -XX:+PerfDisableSharedMem -XX:+UseFastUnorderedTimeStamps -XX:+UseCriticalJavaThreadPriority -XX:+EagerJVMCI -XX:+UseG1GC -XX:MaxGCPauseMillis=37 -XX:+PerfDisableSharedMem \
    -XX:G1HeapRegionSize=16M -XX:G1NewSizePercent=23 -XX:G1ReservePercent=20 -XX:SurvivorRatio=32 -XX:G1MixedGCCountTarget=3 -XX:G1HeapWastePercent=20 -XX:InitiatingHeapOccupancyPercent=10 \
    -XX:G1RSetUpdatingPauseTimePercent=0 -XX:MaxTenuringThreshold=1 -XX:G1SATBBufferEnqueueingThresholdPercent=30 -XX:G1ConcMarkStepDurationMillis=5.0 -XX:G1ConcRSHotCardLimit=16 -XX:G1ConcRefinementServiceIntervalMillis=150 -XX:GCTimeRatio=99 \
    -cp "lunar-lang.jar:lunar-emote.jar:lunar.jar:optifine-0.1.0-SNAPSHOT-all.jar:v1_8-0.1.0-SNAPSHOT-all.jar:common-0.1.0-SNAPSHOT-all.jar:genesis-0.1.0-SNAPSHOT-all.jar" \
    com.moonsworth.lunar.genesis.Genesis \
    --version 1.8.9 \
    --accessToken 0 \
    --launcherVersion 3.1.3 \
    --assetIndex 1.8 \
    --userProperties {} \
    --gameDir "$HOME/.minecraft" \
    --texturesDir "$HOME/.lunarclient/textures" \
    --width 1280 \
    --height 720 \
    --workingDirectory . \
    --classpathDir . \
    --ichorClassPath "lunar-lang.jar,lunar-emote.jar,lunar.jar,optifine-0.1.0-SNAPSHOT-all.jar,v1_8-0.1.0-SNAPSHOT-all.jar,common-0.1.0-SNAPSHOT-all.jar,genesis-0.1.0-SNAPSHOT-all.jar" \
    --ichorExternalFiles OptiFine_v1_8.jar
#echo "$password" | sudo sed -i "/$LUNAR_BLOCKER/d" /etc/hosts #unblock lunar websocket
