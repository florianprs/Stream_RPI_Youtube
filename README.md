# Straem-RPI-to-Youtube

The goal of this project is to use a USB camera connected to a raspberry pi 3 and stream the video on Youtube.

You need : 

- Raspberry pi 3 with raspbian
- a USB camera
- internet connection

To do this project you need to do the following steps: 

1. Update the raspberry : 

use the terminal for the following steps

	sudo apt-get update
	Sudo apt-get upgrade

2. Install h.264 codec

	git clone --depth 1 git://git.videolan.org/x264

	cd x264

	./configure --host=arm-unknown-linux-gnueabi --enable-static --disable-opencl

	make -j2

	sudo make install

3. Install ffmpeg

	cd /usr/src

	sudo git clone https://github.com/FFmpeg/FFmpeg.git

	cd FFmpeg

	sudo ./configure --arch=armel --target-os=linux --enable-gpl --enable-libx264 --enable-nonfree

	make
	
	sudo make install

4. 

	nano stream2youtube.sh

modifie the folowing command to insert your youtube key 

	ffmpeg -thread_queue_size 512 -f v4l2 -i /dev/video0 -f s16le -i /dev/zero -strict experimental -vcodec h264 -preset veryfast -crf 25 -pix_fmt yuv420p -g 60 -vb 820k -maxrate 820k -bufsize 820k -profile:v baseline -r 30 -f flv "rtmp://a.rtmp.youtube.com/live2/"insert_your_youtbe_key""

to find your youtube key you need to go to your Youtube account > Creator studio> Diffusion en Direct (stream or live) you will found on the botom of this page the name or the key of the flux

save and exit 
	
	ctrl+x

5. now you can stream

	bash stream2youtube.sh

