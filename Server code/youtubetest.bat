call _internal\setenv.bat

echo %1

py upload_video.py     --file="C:\DeepFaceLab\DeepFaceLab_NVIDIA\workspace\result.mp4"
                       --title=%1
                       --description=""
                       --keywords=""
                       --category="22"
                       --privacyStatus="public"

PAUSE