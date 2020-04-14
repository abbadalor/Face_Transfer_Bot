@echo off
call _internal\setenv.bat

mkdir "%WORKSPACE%" 2>nul
rmdir "%WORKSPACE%\data_src" /s /q 2>nul
mkdir "%WORKSPACE%\data_src" 2>nul
mkdir "%WORKSPACE%\data_src\aligned" 2>nul
rmdir "%WORKSPACE%\data_dst" /s /q 2>nul
mkdir "%WORKSPACE%\data_dst" 2>nul
mkdir "%WORKSPACE%\data_dst\aligned" 2>nul
rmdir "%WORKSPACE%\model" /s /q 2>nul
mkdir "%WORKSPACE%\model" 2>nul

mkdir "%WORKSPACE%\data_src" 2>nul
mkdir "%WORKSPACE%\data_dst" 2>nul

"%PYTHON_EXECUTABLE%" "%DFL_ROOT%\main.py" videoed extract-video ^
    --input-file "%WORKSPACE%\data_src.*" ^
    --output-dir "%WORKSPACE%\data_src"


"%PYTHON_EXECUTABLE%" "%DFL_ROOT%\main.py" videoed extract-video ^
    --input-file "%WORKSPACE%\data_dst.*" ^
    --output-dir "%WORKSPACE%\data_dst" ^
    --fps 0

"%PYTHON_EXECUTABLE%" "%DFL_ROOT%\main.py" extract ^
    --input-dir "%WORKSPACE%\data_src" ^
    --output-dir "%WORKSPACE%\data_src\aligned" ^
    --detector s3fd

"%PYTHON_EXECUTABLE%" "%DFL_ROOT%\main.py" sort ^
    --input-dir "%WORKSPACE%\data_src\aligned" ^
    --by "blur"

"%PYTHON_EXECUTABLE%" "%DFL_ROOT%\main.py" sort ^
    --input-dir "%WORKSPACE%\data_src\aligned" ^
    --by "face-yaw"

"%PYTHON_EXECUTABLE%" "%DFL_ROOT%\main.py" sort ^
    --input-dir "%WORKSPACE%\data_src\aligned" ^
    --by "face-pitch"

"%PYTHON_EXECUTABLE%" "%DFL_ROOT%\main.py" util ^
    --input-dir "%WORKSPACE%\data_src\aligned" ^
    --recover-original-aligned-filename

"%PYTHON_EXECUTABLE%" "%DFL_ROOT%\main.py" extract ^
    --input-dir "%WORKSPACE%\data_dst" ^
    --output-dir "%WORKSPACE%\data_dst\aligned" ^
    --detector s3fd ^
    --output-debug

"%PYTHON_EXECUTABLE%" "%DFL_ROOT%\main.py" train ^
    --training-data-src-dir "%WORKSPACE%\data_src\aligned" ^
    --training-data-dst-dir "%WORKSPACE%\data_dst\aligned" ^
    --pretraining-data-dir "%INTERNAL%\pretrain_CelebA" ^
    --pretrained-model-dir "%INTERNAL%\pretrain_Quick96" ^
    --model-dir "%WORKSPACE%\model" ^
    --model Quick96 ^
    --force-model-name "" ^
    --force-gpu-idxs "0"

"%PYTHON_EXECUTABLE%" "%DFL_ROOT%\main.py" merge ^
    --input-dir "%WORKSPACE%\data_dst" ^
    --output-dir "%WORKSPACE%\data_dst\merged" ^
    --output-mask-dir "%WORKSPACE%\data_dst\merged_mask" ^
    --aligned-dir "%WORKSPACE%\data_dst\aligned" ^
    --model-dir "%WORKSPACE%\model" ^
    --model Quick96

"%PYTHON_EXECUTABLE%" "%DFL_ROOT%\main.py" videoed video-from-sequence ^
    --input-dir "%WORKSPACE%\data_dst\merged" ^
    --output-file "%WORKSPACE%\result.mp4" ^
    --reference-file "%WORKSPACE%\data_dst.*" ^
    --include-audio

"%PYTHON_EXECUTABLE%" "%DFL_ROOT%\main.py" videoed video-from-sequence ^
    --input-dir "%WORKSPACE%\data_dst\merged_mask" ^
    --output-file "%WORKSPACE%\result_mask.mp4" ^
    --reference-file "%WORKSPACE%\data_dst.*" ^
    --lossless

pause