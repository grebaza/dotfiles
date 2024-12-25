# Get the size of gradle caches, wrappers and daemons in human readable format
# Depends on: du, awk
# Use as: gradleCacheWrapperDaemonsSize
function gradleCacheWrapperDaemonsSize(){
    DIR_TO_CHECK=("caches"  "wrapper"  "daemon")
    for dir in ${DIR_TO_CHECK[*]}; do
        printf "  👉 ~/.gradle/$dir: $(du -sh ~/.gradle/$dir | awk '{ print $1 }')\n"        
    done
}

# Clean up the gradle caches, wrappers and daemons directory of files 
# that were accessed more than 30 days ago and remove empty directories
# Depends on: gradleCacheWrapperDaemonsSize
# Use as: gradleFreeUpSpace
function gradleFreeUpSpace(){
    echo " [BEFORE Cleanup] Gradle caches size:"
    gradleCacheWrapperDaemonsSize
    echo "=========================================================="
    echo " Cleaning up gradle directories ..."
    echo " "
    echo " Working in:"
    DIR_TO_CHECK=("caches"  "wrapper"  "daemon")
    for dir in ${DIR_TO_CHECK[*]}; do
        echo " 👉 ~/.gradle/$dir"
        # Delete all files accessed 30 days ago
        find ~/.gradle/$dir -type f -atime +30 -delete
        # Delete empty directories
        find ~/.gradle/$dir -mindepth 1 -type d -empty -delete
    done
    echo "=========================================================="
    echo " [AFTER Cleanup] Gradle caches size:"
    gradleCacheWrapperDaemonsSize
    echo "=========================================================="
    echo " Done ✅"
}
