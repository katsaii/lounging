releaseargs=""
if [[ $* = *--release* ]]; then
    echo "building for release"
    releaseargs="--audit"
else
    echo "building"
fi
./ringfairy-0.1.3-x86_64-red $releaseargs