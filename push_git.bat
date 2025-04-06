@echo off

:: ǰ������
:: git remote add origin git@gitee.com:feiyu-195/gitbook_notes.git
:: git remote add web-origin git@gitee.com:feiyu-195/gitbook_web.git

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

echo �ϴ��ļ������ֿ� master ����֧...
git push origin master
echo.

echo �ϴ� _book �ļ������Ӳֿ�gitbook_web(master) ��֧...
git subtree push --prefix=_book git@gitee.com:feiyu-195/gitbook_web.git master
echo.

:: �˳��ű�
:: exit
pause