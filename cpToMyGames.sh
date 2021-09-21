# get checksum of current script
BUILD_ID=$(sha1sum script.xs | awk '{print $1}')

# make copies for substituting placeholders with the hash
mkdir -p build
cp script.xs build/script.xs
cp label.xml build/label.xml

# substitute the placeholders in the copies
SED_ARG_BUILDID="s/BUILDID/$BUILD_ID/"
sed -i $SED_ARG_BUILDID build/script.xs
sed -i $SED_ARG_BUILDID build/label.xml

# copy build to game directory
cp build/script.xs /mnt/c/Users/alhoj/Documents/"My Games"/"Age of Mythology"/RM2/$BUILD_ID.xs
cp build/label.xml /mnt/c/Users/alhoj/Documents/"My Games"/"Age of Mythology"/RM2/$BUILD_ID.xml