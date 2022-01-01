# validate path parameter
MAP_DIR_PATH=$1
MAP_NAME=$2 # TODO: validate map name parameter somehow
if [ -z ${MAP_DIR_PATH+x} ];
  then echo "Expected absolute path to map scripts dir and map name and args. Aborting!" && exit 1;
fi

echo "Building '$MAP_NAME'..."

if [ -d "$MAP_DIR_PATH" ];
  then echo "Putting map script files to '$MAP_DIR_PATH'.";
  else echo "Directory '$MAP_DIR_PATH' does not exist. Aborting!" && exit 1;
fi

# get checksum of current script, and date
SCRIPT_CHECKSUM=$(sha1sum src/script.xs | awk '{print $1}')
SCRIPT_CHECKSUM_SHORT=$(echo "$SCRIPT_CHECKSUM" | cut -c1-8)
printf -v CURRENT_DATE '%(%d\/%m\/%Y)T' -1

# make copies for substituting placeholders with the hash
mkdir -p build
cp src/script.xs build/script.xs
cp src/label.xml build/label.xml

# substitute the placeholders in the copies
SED_ARG_CHECKSUM_SHORT="s/SED_CHECKSUM_SHORT/$SCRIPT_CHECKSUM_SHORT/g"
SED_ARG_DATE="s/SED_DATE/$CURRENT_DATE/g"
SED_ARG_MAP_NAME="s/SED_MAP_NAME/$MAP_NAME/g"
sed -i "$SED_ARG_CHECKSUM_SHORT" build/*
sed -i "$SED_ARG_DATE" build/*
sed -i "$SED_ARG_MAP_NAME" build/*

# copy build to game directory
cp build/script.xs "$MAP_DIR_PATH"/$SCRIPT_CHECKSUM.xs
cp build/label.xml "$MAP_DIR_PATH"/$SCRIPT_CHECKSUM.xml

echo "Done. Filenames start with $SCRIPT_CHECKSUM_SHORT."
