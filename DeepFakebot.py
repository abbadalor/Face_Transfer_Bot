from subprocess import Popen
import os
import sys
import requests

os.replace( "videos\data_dst.mp4", "workspace/data_dst.mp4")
os.replace( "videos\data_src.mp4", "workspace/data_src.mp4")

p = Popen("DeepFaceBot.bat", cwd=r"c:\DeepFaceLab\DeepFaceLab_NVIDIA", shell=True)
stdout, stderr = p.communicate()

with open ("title.txt", "r") as myfile:
    title=myfile.read()

p = Popen(["youtubetest.bat", title], cwd=r"c:\DeepFaceLab\DeepFaceLab_NVIDIA", shell=True)
stdout, stderr = p.communicate()
