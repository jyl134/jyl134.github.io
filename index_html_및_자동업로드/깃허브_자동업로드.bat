@echo off
chcp 65001 >nul
echo ========================================================
echo   [이진용 포트폴리오] GitHub Pages (jyl134.github.io) 자동 배포
echo ========================================================
cd /d "%~dp0"

git status >nul 2>&1
if %errorlevel% neq 0 (
    echo [안내] 현재 폴더가 Git 저장소가 아닙니다.
    echo jyl134.github.io 로컬 저장소 폴더 안에서 실행해 주세요!
    pause
    exit /b 1
)

echo [1/3] 변경된 파일 스테이징 중 (git add .)...
git add .

echo [2/3] 커밋 생성 중 (git commit)...
git commit -m "Update portfolio v2: move videos to final step & complete 4-language i18n"

echo [3/3] GitHub 원격 저장소로 푸시 중 (git push)...
git push

echo.
echo ========================================================
echo   ✅ GitHub Pages 배포 완료! (약 1분 후 사이트에 반영됩니다)
echo   👉 https://jyl134.github.io
echo ========================================================
pause
