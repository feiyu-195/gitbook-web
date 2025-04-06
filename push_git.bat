@echo off

:: 前置命令
:: git remote add gitee git@gitee.com:feiyu-195/gitbook_notes.git
:: git remote add github git@github.com:feiyu-195/gitbook-notes.git

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

echo push gitee仓库中...
git push git@gitee.com:feiyu-195/gitbook-notes.git master
echo.

echo push github仓库中...
git push git@github.com:feiyu-195/gitbook-notes.git master
echo.

echo push _book 文件夹至子仓库gitbook_web(master) 分支...
git subtree push --prefix=_book git@gitee.com:feiyu-195/gitbook-web.git master
echo.

echo push _book 文件夹至子仓库gitbook_web(master) 分支...
git subtree push --prefix=_book git@github.com:feiyu-195/gitbook-web.git master
echo.

:: 退出脚本
:: exit
pause