# get checksum of current script
SCRIPT_CHECKSUM=$(sha1sum script.xs | awk '{print $1}')

# make copies for substituting placeholders with the hash
mkdir -p build
cp script.xs build/script.xs
cp label.xml build/label.xml

# substitute the placeholders in the copies
SED_ARG="s/BUILD_ID_PLACEHOLDER/$SCRIPT_CHECKSUM/"
sed -i $SED_ARG build/script.xs
sed -i $SED_ARG build/label.xml

# copy build to game directory
cp build/script.xs /mnt/c/Users/alhoj/Documents/"My Games"/"Age of Mythology"/RM2/$SCRIPT_CHECKSUM.xs
cp build/label.xml /mnt/c/Users/alhoj/Documents/"My Games"/"Age of Mythology"/RM2/$SCRIPT_CHECKSUM.xml