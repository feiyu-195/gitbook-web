@echo off

:: ǰ������
:: git remote add gitee git@gitee.com:feiyu-195/gitbook_notes.git
:: git remote add github git@github.com:feiyu-195/gitbook-notes.git

:: ������־�ļ�·��
set log_file=%~dp0..\push_log.txt

echo ���Ĺ���Ŀ¼...
cd /d "%~dp0"
echo.

echo ��ʼ������ҳ...
call gitbook build
echo.

echo ��������ļ��� Git repository...
git add .
echo.

echo �ύCommit...
git commit -m "feiyu commit"
echo.

echo push gitee�ֿ���...
git push git@gitee.com:feiyu-195/gitbook-notes.git master
echo.

echo push github�ֿ���...
git push git@github.com:feiyu-195/gitbook-notes.git master
echo.

echo push _book �ļ������Ӳֿ�gitbook_web(master) ��֧...
git subtree push --prefix=_book git@gitee.com:feiyu-195/gitbook-web.git master
echo.

echo push _book �ļ������Ӳֿ�gitbook_web(master) ��֧...
git subtree push --prefix=_book git@github.com:feiyu-195/gitbook-web.git master
echo.

:: �˳��ű�
:: exit
pause