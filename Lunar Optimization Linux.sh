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
"$HOME/graal/bin/java" \
    --add-modules jdk.naming.dns \
    --add-exports jdk.naming.dns/com.sun.jndi.dns=java.naming \
    -Djna.boot.library.path=natives \
    -Dlog4j2.formatMsgNoLookups=true \
    --add-opens java.base/java.io=ALL-UNNAMED \
    -Xmx3072m -Xms3072m \
    -Djava.library.path=natives \
    -Xmn1G -XX:+DisableAttachMechanism -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M -XX:+EnableJVMCI -XX:+UseJVMCICompiler -XX:+EagerJVMCI -Djvmci.Compiler=graal \
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
