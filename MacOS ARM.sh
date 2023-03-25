#!/bin/zsh
autoload -Uz colors && colors

GRAAL_SETUP_FILE=$HOME/.graallcsetup.txt

if [ -f "$GRAAL_SETUP_FILE" ]; then
    echo "${fg[yellow]}JRE is already installed, skipping installation${reset_color}"
else
    echo "${fg[red]}downloading GraalVM zip file${reset_color}"
    curl -o "$HOME/graalvm.zip" 'https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.3.1/graalvm-ce-java17-darwin-aarch64-22.3.1.tar.gz'

    echo "${fg[red]}extracting files to user directory and rename folder${reset_color}"
    tar -xzf "$HOME/graalvm.zip" -C "$HOME/"
    mv "$HOME/graalvm-ce-java17-22.3.1" "$HOME/graal"

    echo "${fg[red]}setting environment variable for GraalVM location${reset_color}"
    echo 'export GRAALVM_HOME="$HOME/graal"' >> ~/.zshrc
    export GRAALVM_HOME="$HOME/graal"

    echo "${fg[red]}creating setup file to indicate that JRE is installed${reset_color}"
    echo "JRE is installed" > "$GRAAL_SETUP_FILE"
fi

echo "${fg[green]}Launching Lunarclient${reset_color}"
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
    --ichorClassPath "v1_7-0.1.0-SNAPSHOT-all.jar:lunar-lang.jar:lunar.jar:optifine-0.1.0-SNAPSHOT-all.jar:common-0.1
