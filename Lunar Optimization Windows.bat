@echo off
color 4
set GRAAL_SETUP_FILE=%USERPROFILE%\.graallcsetup.txt

if exist "%GRAAL_SETUP_FILE%" (
    echo JRE is already installed, skipping installation
) else (
    echo downloading GraalVM zip file
    powershell -command "& { Invoke-WebRequest -Uri 'https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.3.1/graalvm-ce-java17-windows-amd64-22.3.1.zip' -OutFile '%USERPROFILE%\graalvm.zip' }"

    echo extracting files to user directory and rename folder
    powershell -command "& { Expand-Archive -Path '%USERPROFILE%\graalvm.zip' -DestinationPath '%USERPROFILE%\' }"
    powershell -command "& { Rename-Item -Path '%USERPROFILE%\graalvm-ce-java17-22.3.1' -NewName 'graal' }"

    echo setting environment variable for GraalVM location
    setx GRAALVM_HOME "%USERPROFILE%\graal"

    echo creating setup file to indicate that JRE is installed
    echo JRE is installed > "%GRAAL_SETUP_FILE%"
)
color 2
echo Launching Lunarclient
cd "%USERPROFILE%\.lunarclient\offline\multiver\"
"%USERPROFILE%\graal\bin\java" ^
    --add-modules jdk.naming.dns ^
    --add-exports jdk.naming.dns/com.sun.jndi.dns=java.naming ^
    -Djna.boot.library.path=natives ^
    -Dlog4j2.formatMsgNoLookups=true ^
    --add-opens java.base/java.io=ALL-UNNAMED ^
    -Xmx3072m -Xms3072m ^
    -Djava.library.path=natives ^
    -Xmn1G -XX:+DisableAttachMechanism -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M -XX:+EnableJVMCI -XX:+UseJVMCICompiler -XX:+EagerJVMCI -Djvmci.Compiler=graal ^
    -cp "v1_7-0.1.0-SNAPSHOT-all.jar;lunar-lang.jar;lunar.jar;optifine-0.1.0-SNAPSHOT-all.jar;common-0.1.0-SNAPSHOT-all.jar;genesis-0.1.0-SNAPSHOT-all.jar;OptiFine_1.7.10_HD_U_E7" ^
    com.moonsworth.lunar.genesis.Genesis ^
    --version 1.7.10 ^
    --accessToken 0 ^
    --assetIndex 1.7.10 ^
    --userProperties {} ^
    --gameDir "%USERPROFILE%\.minecraft" ^
    --texturesDir "%USERPROFILE%\.lunarclient\textures" ^
    --width 1280 ^
    --height 720 ^
    --workingDirectory . ^
    --classpathDir . ^
    --ichorClassPath "v1_7-0.1.0-SNAPSHOT-all.jar;lunar-lang.jar;lunar.jar;optifine-0.1.0-SNAPSHOT-all.jar;common-0.1.0-SNAPSHOT-all.jar
