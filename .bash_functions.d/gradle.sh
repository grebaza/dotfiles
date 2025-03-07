# Gradle cache cleanup script
# - Displays the size of caches, wrappers, and daemons in human-readable format
# - Deletes files not accessed in over 30 days and removes empty directories

# Global variables
GRADLE_HOME="${HOME}/.gradle"
DIRS=(caches wrapper daemon)

gradleCacheWrapperDaemonsSize() {
  local dir size dummy
  for dir in "${DIRS[@]}"; do
    if [[ -d "$GRADLE_HOME/$dir" ]]; then
      # Use built-in read to capture the size from du, avoiding awk/cut
      read -r size dummy < <(du -sh "$GRADLE_HOME/$dir" 2>/dev/null)
      printf "  👉 %s: %s\n" "$GRADLE_HOME/$dir" "$size"
    else
      printf "  👉 %s: not found\n" "$GRADLE_HOME/$dir"
    fi
  done
}

gradleFreeUpSpace() {
  echo " [BEFORE Cleanup] Gradle caches size:"
  gradleCacheWrapperDaemonsSize
  cat <<'EOF'
==========================================================
 Cleaning up gradle directories ...

 Working in:
EOF

  local dir
  for dir in "${DIRS[@]}"; do
    echo " 👉 $GRADLE_HOME/$dir"
    if [[ -d "$GRADLE_HOME/$dir" ]]; then
      # Delete files not accessed in over 30 days and remove empty directories
      find "$GRADLE_HOME/$dir" -type f -atime +30 -delete
      find "$GRADLE_HOME/$dir" -mindepth 1 -type d -empty -delete
    fi
  done

  cat <<'EOF'
==========================================================
 [AFTER Cleanup] Gradle caches size:
EOF
  gradleCacheWrapperDaemonsSize
  cat <<'EOF'
==========================================================
 Done ✅
EOF
}

