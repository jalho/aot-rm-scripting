# validate path parameter
MAP_DIR_PATH=$1
if [ -z ${MAP_DIR_PATH+x} ];
  then echo "Expected absolute path to map scripts dir and map name and args. Aborting!" && exit 1;
fi

SCRIPT_SRC="src/script.xs"
CYAN='\033[0;36m'
NOCOLOR='\033[0m'

# get map name from the docstring that is in the beginning of the .xs file
MAP_NAME=$(head -n 2 $SCRIPT_SRC | awk 'match($0, /\*{2} (.*\w$)/, m) {print m[1]}')
echo -e "Map name is $CYAN$MAP_NAME$NOCOLOR."

if [ -d "$MAP_DIR_PATH" ];
  then echo "Putting map script files to '$MAP_DIR_PATH'.";
  else echo "Directory '$MAP_DIR_PATH' does not exist. Aborting!" && exit 1;
fi

# get checksum of current script, and date
SCRIPT_CHECKSUM=$(sha1sum $SCRIPT_SRC | awk '{print $1}')
SCRIPT_CHECKSUM_SHORT=$(echo "$SCRIPT_CHECKSUM" | cut -c1-8)
printf -v CURRENT_DATE '%(%d\/%m\/%Y)T' -1

# make copies for substituting placeholders with the hash
mkdir -p build
cp $SCRIPT_SRC build/script.xs
cp src/label.xml build/label.xml

# substitute the placeholders in the copies; "-i" to edit files in-place
SED_ARG_CHECKSUM_SHORT="s/SED_CHECKSUM_SHORT/$SCRIPT_CHECKSUM_SHORT/"
SED_ARG_DATE="s/SED_DATE/$CURRENT_DATE/"
SED_ARG_MAP_NAME="s/SED_MAP_NAME/$MAP_NAME/"
sed -i "$SED_ARG_CHECKSUM_SHORT" build/*
sed -i "$SED_ARG_DATE" build/*
sed -i "$SED_ARG_MAP_NAME" build/*

# copy build to game directory
OUT_FILENAME=$(echo "$MAP_NAME-$CURRENT_DATE-SHA-$SCRIPT_CHECKSUM_SHORT" | sed -r s/[\ \/\\]//g) # remove all " ", "/" and "\" from filename
echo -e "Using filename $CYAN$OUT_FILENAME$NOCOLOR (.xml and .xs)."
cp build/script.xs "$MAP_DIR_PATH"/$OUT_FILENAME.xs
cp build/label.xml "$MAP_DIR_PATH"/$OUT_FILENAME.xml

echo "Done!"
