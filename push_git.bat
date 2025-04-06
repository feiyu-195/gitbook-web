@echo off

:: ǰ������
:: git remote add origin git@gitee.com:feiyu-195/gitbook_notes.git
:: git remote add web-origin git@gitee.com:feiyu-195/gitbook_web.git

:: ������־�ļ�·��
set log_file=%~dp0..\push_log.txt

:: ����������ض�����־�ļ�
(
    echo ���Ĺ���Ŀ¼...
    cd /d "%~dp0"
    echo.
) > "%log_file%" 2>&1
(
    echo ��ʼ������ҳ...
    call gitbook build
    echo.
) >> "%log_file%" 2>&1
(
    echo ��������ļ��� Git repository...
    git add .
    echo.
) >> "%log_file%" 2>&1
(
    echo �ύCommit...
    git commit -m "Feiyu"
    echo.
) >> "%log_file%" 2>&1
(
    echo �ϴ��ļ������ֿ� master ����֧...
    git push origin master
    echo.
) >> "%log_file%" 2>&1
(
    echo ���� _book �ļ���Ϊ�·�֧web...
    git subtree split -P _book -b web
    echo.
) >> "%log_file%" 2>&1
(
    echo �ϴ� _book �ļ������Ӳֿ� master ��֧...
    git push web-origin web:master
    echo.
) >> "%log_file%" 2>&1

:: �˳��ű�
exit