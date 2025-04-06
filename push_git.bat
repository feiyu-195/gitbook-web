@echo off

:: 前置命令
:: git remote add origin git@gitee.com:feiyu-195/gitbook_notes.git
:: git remote add web-origin git@gitee.com:feiyu-195/gitbook_web.git

:: 设置日志文件路径
set log_file=%~dp0..\push_log.txt

echo 更改工作目录...
cd /d "%~dp0"
echo.

echo 开始构建网页...
call gitbook build
echo.

echo 添加所有文件至 Git repository...
git add .
echo.

echo 提交Commit...
git commit -m "feiyu commit"
echo.

echo 上传文件至父仓库 master 主分支...
git push origin master
echo.

echo 分离 _book 文件夹为新分支web...
git subtree split -P _book -b web
echo.

echo 上传 _book 文件夹至子仓库 master 分支...
git push web-origin web:master --force
echo.

:: 退出脚本
exit