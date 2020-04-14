# Face Transfer Bot

This is a bot that will take two videos of people and a title and use DeepFaceLab 2.0 to create a deepfake of the two videos and upload it
to https://www.youtube.com/channel/UC-AgGSZd0D57RC1UJuncTZA.

This project works by contacting my ssh server on my computer and uploading the video files and then launching a script that makes the DeepFake. The script works by using a version of DeepFaceLab 2.0 that I modified to be able to be used purely by a single batch file without any manual inputs, It also automatically removes blurry, dark, and too rotated images from the video to be used the model. After the video is created it is uploaded to a youtube channel using Youtube:s Data API.

## Usage
To use this bot you need to download the **sshconnect.py** file from this repository and put it in a folder with 
another folder labeled videos like this:

folder/

├── sshconnect.py   
└── videos/

..........├── data_src.mp4

..........└── data_dst.mp4

data_src.mp4 should be the video with the person who's face you want to put over the other video
data_dst.mp4 should be the video that you want to overlay the face on

Then you just need to start **sshconnect.py** and enter your chosen title when asked and then wait (a very long time) for it to be uploaded to https://www.youtube.com/channel/UC-AgGSZd0D57RC1UJuncTZA.

### Dependencies
paramiko

scp from SCPClient

## Files
**sshconnect.py** is the file that needs to be on the client computer that starts the bot.

Inside **Server code** is all the code located on the server
- **DeepFakebot.py** is the script that moves the videos to the correct folder and starts all the other needed scripts
- **DeepFacebot.bat** is a batch file that automatically extracts faces from the videos and trains the model using DeepFaceLab
- **youtubetest.bat** is a batch file (Which I forgot to rename) that launches **upload_video.py** with all the required parameters in order to upload the final video to youtube
- The **DeepFaceLab** folder has some of the code from DeepFaceLab 2.0, mostly the code I modified to run without manual input

## Problems
While the code works the hardware I use for it is less than optimal for training models so a video can take more than 24 hours to upload. I could decrease the time by using my laptop which has a much better graphics card but then I would not be able to use it for other things while it is running.

## Improvments
I would like to implement some way to monitor progress on the model as it is trained as it is impossible to see the logs that normally appear during the progress when the code is started remotly.
