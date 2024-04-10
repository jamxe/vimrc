ffmpeg -i "${1?video}" -i "${2?audio}" -c:v copy -map 0:v -map 1:a -y /tmp/out.mp4
