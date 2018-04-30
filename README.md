# Stream-RPI-to-Youtube

When you buy a Raspberry Pi, you are looking probably for a nice project to practice with Python or to try the possibility of your device. The project I propose you is a interesting project to control your Pi, a camera (here a USB camera) and a web interface (here a channel YouTube) in a same work. 
The goal of this tutorial is to use a USB camera connected to a raspberry pi 2 & 3 and live stream this video on an Youtube channel.

## What you will need 

You will need the following: 

- Raspberry pi 2 or 3 with the last version of Raspbian
- an USB camera
- an internet connection
- an YouTube account 

We will also use the ffmpeg library. So if this library is corrected installed on you Raspberry Pi, skip the point 3 ofthe tutorial about ffmpeg installation. 

### 1. Update your Raspberry Pi

To install the ffmpeg library, it is important to have a recent version of Raspbian. 

Open a terminal and insert this lines : 

```

sudo apt-get update 

sudo apt-get upgrade

```
Generally, the second line takes a lot of time of processing. So you can go directly to the point 2 during this time. But when this command is finished, do this line before to continue to point 4. 

```

sudo apt-get update

```

### 2. Get the key of your YouTube channel 

To stream on your own YouTube channel, you need to get your "Stream key". It is a key that is working only on you YouTube channel and give you the right to stream on this. 
So, connect you to you YouTube channel. 
Then, go to creator studio. 
Next, go to live streaming. 
Now, go above the page and keep the "Stream name/key"
Reveal your Stream key and keep this information for later. 

### 3. Install camera

It is really simple. Plug your USB camera on the left top Raspberry Pi USB connector.

### 4. Install ffmpeg

Now, when you are finished to update your Raspberry Pi, it is time to install the ffmpeg library. As I said above, you have not to do this part if you already have a ffmpeg library correctly installed on your Raspberry Pi. 

#### 1. Create an empty file to hold the script code:

```

mkdir /home/pi/tools
cd /home/pi/tools
sudo nano ffmpeg-install.sh

```

#### 2. Cut and Paste the script code into the file.

```

#!/bin/bash
# Compile and install (or install via Apt) FFmpeg Codecs
# Compile and install FFmpeg suite

echo "Begining Installation of FFmpeg Suite"

#Update APT Repository
echo "Updating the APT repository information"
apt-get update

#Create Working Directories
echo "Setting up working directories to be used during the installation and build process"
cd ~
mkdir ~/ffmpeg_sources
mkdir ~/ffmpeg_build

#Build Tools
echo "Installing various tools and packages, including audio-video codecs, required for building FFmpeg"
apt-get -y install autoconf automake build-essential libass-dev libfreetype6-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev

 #YASM Assembler
echo "Installing the YASM Assembler"
apt-get install -y yasm

echo "Compiling and Installing FFmpeg Codecs"

#x264 Codec
echo "X264 Codec"
cd /home/pi/ffmpeg_sources
git clone git://git.videolan.org/x264
cd x264
./configure --host=arm-unknown-linux-gnueabi --enable-shared --disable-opencl
make -j2
make install
make clean
make distclean

 echo "Libfdk-aac Codec"
cd ~/ffmpeg_sources
wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master
tar xzvf fdk-aac.tar.gz
cd mstorsjo-fdk-aac*
autoreconf -fiv
./configure  --enable-shared
make -j2
make install
make clean
make distclean

 #Libmp3lame Codec 
echo "Libmp3lame Codec"
apt-get install -y libmp3lame-dev

#Libopus Codec
echo "Libopus Codec"
apt-get install -y libopus-dev

#Libvpx Codec
echo "Libvpx Codec"
cd ~/ffmpeg_sources
wget http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.5.0.tar.bz2
tar xjvf libvpx-1.5.0.tar.bz2
cd libvpx-1.5.0
PATH="$HOME/bin:$PATH" ./configure --enable-shared --disable-examples --disable-unit-tests
PATH="$HOME/bin:$PATH" make -j2
make install
make clean
make distclean

 # FFmpeg Suite
echo "Compiling and installing the FFmpeg Suite"
cd ~/ffmpeg_sources
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg

PATH="$HOME/bin:$PATH" ./configure \
  --pkg-config-flags="--static" \
  --extra-cflags="-fPIC -I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-nonfree \
  --enable-pic \
  --extra-ldexeflags=-pie \
  --enable-shared

PATH="$HOME/bin:$PATH" make -j2
make install
make distclean
hash -r

#Update Shared Library Cache
echo "Updating Shared Library Cache"
ldconfig

echo "FFmpeg and Codec Installation Complete"

```

#### 3. Save the result:

  Ctrl + X, then y

#### 4. Mark the script file as Executable:

```

sudo chmod +x ffmpeg-install.sh

```

#### 5. Run the script:

```
sudo ./ffmpeg-install.sh

```

The script completes in approximately 1 hour on a Raspberry Pi 3. So, don't hesitate to make a break and why not watch an episode on Netflix ! ;-) 

### 5. Set the parameter of the stream

After it is finished, you can know make a test to see if the ffmpeg is correcty installed. 

```
ffmpeg

```

Then, if you receive the information about ffmpeg, you can continue. 

Create a file to insert the command

	nano stream2youtube.sh


Then, copy past this command on this file (Don't forget to change your YouTube key in the code) : 

```
ffmpeg -thread_queue_size 512 -f v4l2 -i /dev/video0 -f s16le -i /dev/zero -strict experimental -vcodec h264 -preset veryfast -crf 25 -pix_fmt yuv420p -g 60 -vb 820k -maxrate 820k -bufsize 820k -profile:v baseline -r 30 -f flv "rtmp://a.rtmp.youtube.com/live2/"insert_your_youtbe_key""

```

You can find the specifications of each terms to this link : ` http://www.ffmpeg.org/ffmpeg.html `

After that, save and exit 
	
	ctrl+x


Now, you will start a command to stream directry on your YouTube channel. 

	bash stream2youtube.sh


### 6. Check your stream on YouTube
 
 Return on your YouTube channel (like before : connect you to you YouTube channel. Then, go to creator studio. Next, go to live streaming. ). And, you will have normally your live streaming on your YouTube channel. Congratulation ! 
