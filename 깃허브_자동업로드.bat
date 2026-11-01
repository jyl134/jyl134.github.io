@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
echo ========================================================
echo   [이진용 포트폴리오] GitHub Desktop 연동 자동 배포
echo ========================================================
cd /d "%~dp0"

if not exist "%~dp0index.html" (
    echo [!] 압축을 풀지 않고 압축파일 안에서 바로 실행하셨습니다!
    echo 먼저 압축파일을 폴더에 [압축 풀기] 한 뒤 실행해 주세요.
    pause
    exit /b 1
)

REM 1. Find GitHub Desktop bundled git.exe if system git is not in PATH
where git >nul 2>&1
if %errorlevel% neq 0 (
    for /d %%D in ("%LOCALAPPDATA%\GitHubDesktop\app-*") do (
        if exist "%%~fD\resources\app\git\cmd\git.exe" (
            set "PATH=%%~fD\resources\app\git\cmd;!PATH!"
        )
    )
)

REM 2. Check if Documents\GitHub\jyl134.github.io exists (GitHub Desktop default clone path)
set "GHD_REPO=%USERPROFILE%\Documents\GitHub\jyl134.github.io"
if exist "%GHD_REPO%\.git" (
    echo [진행] GitHub Desktop 저장소 폴더(%GHD_REPO%)를 찾았습니다!
    echo 최신 index.html 및 이미지/GIF 파일을 저장소로 복사합니다...
    copy /Y "%~dp0index.html" "%GHD_REPO%\index.html" >nul
    for %%F in ("%~dp0*.png" "%~dp0*.jpg" "%~dp0*.gif" "%~dp0*.srt") do (
        if exist "%%~fF" copy /Y "%%~fF" "%GHD_REPO%\" >nul
    )
    cd /d "%GHD_REPO%"
    git add . >nul 2>&1
    git commit -m "Update portfolio v2: move videos to final step & complete 4-language i18n" >nul 2>&1
    git push >nul 2>&1
    if !errorlevel! equ 0 (
        echo.
        echo ========================================================
        echo   ✅ GitHub Pages 자동 푸시 완료! (1~2분 뒤 사이트 반영)
        echo   👉 https://jyl134.github.io
        echo ========================================================
        start "" "https://jyl134.github.io"
        pause
        exit /b 0
    ) else (
        echo.
        echo ========================================================
        echo   ✅ GitHub Desktop 폴더로 파일 복사가 완료되었습니다!
        echo   이제 열린 [GitHub Desktop] 창에서:
        echo   1) 왼쪽 아래 Summary 칸에 "업데이트" 입력 후 [Commit to main] 클릭
        echo   2) 상단 [Push origin] 버튼 클릭하면 배포 끝!
        echo ========================================================
        if exist "%LOCALAPPDATA%\GitHubDesktop\GitHubDesktop.exe" start "" "%LOCALAPPDATA%\GitHubDesktop\GitHubDesktop.exe"
        pause
        exit /b 0
    )
)

REM 3. Check if current folder itself is a git repo
git rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel% equ 0 (
    echo [진행] 현재 Git 저장소에서 바로 업로드합니다...
    git add .
    git commit -m "Update portfolio v2: move videos to final step & complete 4-language i18n"
    git push
    echo.
    echo ========================================================
    echo   ✅ 작업 완료! 만약 푸시가 안 되었다면 GitHub Desktop에서
    echo   [Commit to main] -> [Push origin]을 눌러주세요!
    echo ========================================================
    if exist "%LOCALAPPDATA%\GitHubDesktop\GitHubDesktop.exe" start "" "%LOCALAPPDATA%\GitHubDesktop\GitHubDesktop.exe"
    pause
    exit /b 0
)

echo [안내] 아직 GitHub Desktop에서 jyl134.github.io 저장소를 불러오지(Clone) 않으셨습니다!
echo GitHub Desktop을 열어드리니 [jyl134/jyl134.github.io]를 Clone 해주세요.
if exist "%LOCALAPPDATA%\GitHubDesktop\GitHubDesktop.exe" start "" "%LOCALAPPDATA%\GitHubDesktop\GitHubDesktop.exe"
pause
