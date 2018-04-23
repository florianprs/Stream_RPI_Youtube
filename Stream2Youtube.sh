#!/bin/bash

ffmpeg -thread_queue_size 512 -f v4l2 -i /dev/video0 \
   -f s16le -i /dev/zero -strict experimental \
   -vcodec h264 -preset veryfast -crf 25 -pix_fmt yuv420p -g 60 -vb 820k -maxrate 820k -bufsize 820k -profile:v baseline \
  -r 30 -f flv "rtmp://a.rtmp.youtube.com/live2/"insert_your_youtbe_key""