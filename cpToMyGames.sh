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
sed -i $SED_ARG_CHECKSUM_SHORT build/*
sed -i $SED_ARG_DATE build/*

# copy build to game directory
cp build/script.xs /mnt/c/Users/alhoj/Documents/"My Games"/"Age of Mythology"/RM2/$SCRIPT_CHECKSUM.xs
cp build/label.xml /mnt/c/Users/alhoj/Documents/"My Games"/"Age of Mythology"/RM2/$SCRIPT_CHECKSUM.xml