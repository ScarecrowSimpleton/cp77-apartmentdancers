#!/bin/bash
#
# Basic script to pack the mod ready for game installtion
#
# Usage: ./build.sh [OPTION...]
#    (none)                           Build developent version
#    beta [vers_sion] [ver.sion] [id] Build beta release version
#    release [ver_sion] [ver.sion]    Build release version
#    clean                            Cleanup build directory (WARNING: Be careful! Destructive!)"
#    help                             Print This help message

# Set mod name and author
MODNAME="ApartmentDancers"
MODAUTHOR="ScarecrowSimpleton"

# Setup paths
BUILDDIR="$(pwd)/build"
WORKDIR="$BUILDDIR/work"
AMMDECORDIR="$WORKDIR/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/User/Decor/"
CSDATAPACKDIR="$WORKDIR/bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/datapack/ApartmentDancers"

# Zip Info
ZIPLEVEL="9" # 1 L, 9 H

# Catch input
if [[ -n $1 ]]; then
   if [ $1 = "help" ]; then
      echo "Basic script to pack the mod ready for game installtion"
      echo
      echo "Usage: ./build.sh [OPTION...]"
      echo "    (none)                           Build developent version"
      echo "    beta [ver_sion] [ver.sion] [id]  Build beta release version"
      echo "    release [ver_sion] [ver.sion]    Build release version"
      echo "    clean                            Cleanup build directory (WARNING: Be careful! Destructive!)"
      echo "    help                             Print This help message"
      exit
   elif [ $1 = "clean" ]; then
      rm -Rfv "$WORKDIR"
      exit
   elif [ $1 = "beta" ]; then
      if [[ -n "$2" ]]; then
         if [[ -n "$3" ]]; then
            if [[ -n "$4" ]]; then
               VERTEXT="beta"
               VERTAG="_v"
               BETATAG="_beta_"
               MODARC="$MODNAME$VERTAG$2$BETATAG$4"
               PACKCOMMENT="$MODNAME v$3 $VERTEXT $4 by $MODAUTHOR"
            else
               VERTEXT="beta"
               VERTAG="_v"
               BETATAG="_beta"
               MODARC="$MODNAME$VERTAG$2$BETATAG"
               PACKCOMMENT="$MODNAME v$3 $VERTEXT by $MODAUTHOR"
            fi
         else
            echo "ERROR: Human readable version not set!"
            exit
         fi
      else
         echo "ERROR: Release version not set!"
         exit
      fi
   elif [ $1 = "release" ]; then
      if [[ -n "$2" ]]; then
         if [[ -n "$3" ]]; then
            VERTAG="_v"
            MODARC="$MODNAME$VERTAG$2"

            PACKCOMMENT="$MODNAME v$3$VERTEXT by $MODAUTHOR"
         else
            echo "ERROR: Human readable version not set!"
            exit
         fi
      else
         echo "ERROR: Release version not set!"
         exit
      fi
   else
      echo "Unrecognised argument $1"
      exit
   fi
else
   VERTEXT="DEV"
   VERTAG="_vDEV"
   MODARC="$MODNAME$VERTAG"
   PACKCOMMENT="$MODNAME v$VERTEXT by $MODAUTHOR"
fi

# Create structure
mkdir -pv "$AMMDECORDIR" "$CSDATAPACKDIR"

# Copy data
cp -prv amm-objects/* "$AMMDECORDIR"
cp -prv cyberscript/* "$CSDATAPACKDIR"

# Pack Mod
cd "$WORKDIR"
zip -FS -$ZIPLEVEL -r "$BUILDDIR/$MODARC.zip" *
echo "$PACKCOMMENT" > pack-version
zip -z "$BUILDDIR/$MODARC.zip" < pack-version
rm pack-version

# Check packed integrity of modification
cd "$BUILDDIR"
7z t $MODARC.zip

# Calculate sum
sha256sum $MODARC.zip > sha256sum

echo
echo "Archive created! Archive has the following sum:"
cat sha256sum
echo
echo "Sum has been saved in sha256sum file"

exit
