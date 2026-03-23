addyt() {
  local url="$1"
  
  # Check dependencies
  for cmd in yt-dlp ffmpeg ffprobe jq; do
    command -v "$cmd" >/dev/null || { echo "Error: $cmd not found"; return 1; }
  done
  
  local temp_dir=$(mktemp -d /tmp/yt-dlp.XXXXXX)
  
  yt-dlp --cookies-from-browser firefox "$url" -x --audio-format mp3 --embed-metadata -o "$temp_dir/%(title)s.%(ext)s" || {
    echo "Download failed"
    rm -rf "$temp_dir"
    return 1
  }
  
  for file in "$temp_dir"/*.mp3; do  # Fixed glob pattern
    [ -f "$file" ] || continue
    artist=$(ffprobe -v quiet -print_format json -show_format "$file" | jq -r '.format.tags.artist // ""')
    album=$(ffprobe -v quiet -print_format json -show_format "$file" | jq -r '.format.tags.album // ""')
    title=$(ffprobe -v quiet -print_format json -show_format "$file" | jq -r '.format.tags.title // ""')
    track=$(ffprobe -v quiet -print_format json -show_format "$file" | jq -r '.format.tags.track // "1"')
    track_num=$(printf "%02d" "${track%%/}")
    if [ -z "$artist" ]; then
      base=$(basename "$file" .mp3)
      if [[ $base =~ ^([^-]+)-[[:space:]](.+)$ ]]; then
        new_artist=$(echo "${BASH_REMATCH[1]}" | sed 's/^[[:space:]]//;s/[[:space:]]$//')
        new_title=$(echo "${BASH_REMATCH[2]}" | sed 's/^[[:space:]]//;s/[[:space:]]*$//')
      else
        new_artist="Unknown"
        new_title="$base"
      fi
      ffmpeg -i "$file" -metadata artist="$new_artist" -metadata title="$new_title" -codec copy "$file.new.mp3"
      mv "$file.new.mp3" "$file"
      artist="$new_artist"
      title="$new_title"
    fi
    if [ -z "$album" ]; then
      ffmpeg -i "$file" -metadata album="Unknown" -codec copy "$file.new.mp3"
      mv "$file.new.mp3" "$file"
      album="Unknown"
    fi
    mkdir -p ~/Music/"$artist"/"$album"
    mv "$file" ~/Music/"$artist"/"$album"/"$track_num - $title.mp3"
  done
  
  rm -rf "$temp_dir"
}
