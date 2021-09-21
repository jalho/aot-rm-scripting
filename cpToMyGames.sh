BUILD_ID=$(sha1sum script.xs | awk '{print $1}')
SED_ARG="s/BUILDID/$BUILD_ID/"
mkdir -p build
cp script.xs build/script.xs
cp label.xml build/label.xml
sed -i $SED_ARG build/script.xs
sed -i $SED_ARG build/label.xml
cp build/script.xs /mnt/c/Users/alhoj/Documents/"My Games"/"Age of Mythology"/RM2/$BUILD_ID.xs
cp build/label.xml /mnt/c/Users/alhoj/Documents/"My Games"/"Age of Mythology"/RM2/$BUILD_ID.xml