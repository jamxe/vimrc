#!/bin/bash

set -e
i=1000
speed=1.5
# rm -rf /tmp/o_*.ts
rm -rf /tmp/t_*.ts
for x in $*; do
    i=$[$i + 1]
    ffmpeg -y -i $x -vcodec copy -acodec copy -vbsf h264_mp4toannexb /tmp/t_$i.ts
    # ffmpeg -y -hwaccel cuda -c:v h264_cuvid -i /tmp/o_$i.ts -filter_complex "[0:v]setpts=$invspeed*PTS [v]; [0:a]atempo=$speed [a]" -map "[v]" -map "[a]" -c:v h264_nvenc /tmp/t_$1.ts
done
# (for x in $*; do
#     i=$[$i + 1]
#     ffmpeg -y -i $x -vcodec copy -acodec copy -vbsf h264_mp4toannexb /tmp/o_$i.ts
#     echo $i
# done) | parallel -j 8 -I% --max-args 1 $(dirname $0)/speedup.sh /tmp/o_%.ts /tmp/t_%.ts $speed
cat /tmp/t_*.ts > /tmp/a_a.ts
ffmpeg -y -i /tmp/a_a.ts -acodec copy -vcodec copy -absf aac_adtstoasc /tmp/out.mp4
rm -f /tmp/a_a.ts /tmp/t_*.ts
