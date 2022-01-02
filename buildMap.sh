# validate PWD; must be in dir "aot-rm-sandbox"
PWD_TAIL15=$(echo $PWD | tail -c 15)
if [ $PWD_TAIL15 != "aot-rm-sandbox" ];
  then echo "Must start in project root." && exit 1;
fi;

# validate args count
if [ $# -ne 2 ];
  then echo "Give map src dir and absolute target map scripts dir path as args." && exit 1;
fi

# colors
CYAN='\033[0;36m'
NOCOLOR='\033[0m'

# get args
MAP_SRC_DIR=$1
MAP_TARGET_PATH=$2
SCRIPT_SRC="maps/$MAP_SRC_DIR/src/script.xs"
LABEL_SRC="maps/$MAP_SRC_DIR/src/label.xml"

if [ -d maps/$MAP_SRC_DIR ];
  then echo -e "Map src dir: $CYAN$MAP_SRC_DIR$NOCOLOR.";
  else echo "Path doesn't exist: maps/$MAP_SRC_DIR" && exit 1;
fi;

# validate target path; must exist
if [ -d "$MAP_TARGET_PATH" ];
  then echo -e "Putting map script files to $CYAN$MAP_TARGET_PATH$NOCOLOR.";
  else echo "Directory '$MAP_TARGET_PATH' does not exist. Aborting!" && exit 1;
fi

# get map name from the docstring that is in the beginning of the .xs file
MAP_NAME=$(head -n 2 $SCRIPT_SRC | awk 'match($0, /\*{2} (.*\w$)/, m) {print m[1]}')
echo -e "Map name is $CYAN$MAP_NAME$NOCOLOR."

# get checksum of current script, and date
SCRIPT_CHECKSUM=$(sha1sum $SCRIPT_SRC | awk '{print $1}')
SCRIPT_CHECKSUM_SHORT=$(echo "$SCRIPT_CHECKSUM" | cut -c1-8)
printf -v CURRENT_DATE '%(%d\/%m\/%Y)T' -1

# make copies for substituting the placeholders
mkdir -p maps/$MAP_SRC_DIR/build
cp $SCRIPT_SRC maps/$MAP_SRC_DIR/build/script.xs
cp $LABEL_SRC maps/$MAP_SRC_DIR/build/label.xml

# substitute the placeholders in the copies; "-i" to edit files in-place
SED_ARG_CHECKSUM_SHORT="s/SED_CHECKSUM_SHORT/$SCRIPT_CHECKSUM_SHORT/"
SED_ARG_DATE="s/SED_DATE/$CURRENT_DATE/"
SED_ARG_MAP_NAME="s/SED_MAP_NAME/$MAP_NAME/"
sed -i "$SED_ARG_CHECKSUM_SHORT" maps/$MAP_SRC_DIR/build/*
sed -i "$SED_ARG_DATE" maps/$MAP_SRC_DIR/build/*
sed -i "$SED_ARG_MAP_NAME" maps/$MAP_SRC_DIR/build/*

# copy build to game directory
OUT_FILENAME=$(echo "$MAP_NAME-$SCRIPT_CHECKSUM_SHORT" | sed -r s/[\ \/\\]//g) # remove all " ", "/" and "\" from filename
echo -e "Using filename $CYAN$OUT_FILENAME$NOCOLOR (.xml and .xs)."
cp maps/$MAP_SRC_DIR/build/script.xs "$MAP_TARGET_PATH"/$OUT_FILENAME.xs
cp maps/$MAP_SRC_DIR/build/label.xml "$MAP_TARGET_PATH"/$OUT_FILENAME.xml

echo "Done!"
