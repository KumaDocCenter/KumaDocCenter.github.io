:: ============================================================================= ::
:: ����һλ�ô����Ӳֿ�Ŀ�Ŀ¼
::
:: ����ָ��Ŀ¼�µ� Ŀ¼�����ĺ�׺ .bak ���д���
:: .bak ��׺��Ŀ¼��ͨ��Ϊ�Ӳֿ��ʼ��ǰ�ı���
:: 
:: ע���ű���DevDocCenterĿ¼ͬ������ 
::
:: ���Ŀ¼�� 
:: ����Ŀ¼�� 
:: 
:: ============================================================================= ::

:: �رջ���
@echo off
:: ���������ӳ�
setlocal enabledelayedexpansion

:: ���Կ���
set debug=0

:: �洢��̾�� ! 
set "T=^!"

set spath=DevDocCenter
set dpath=DevDocCenter_md

cd %~dp0

:: ���ø�Ŀ¼·��
set root=%cd%
:: ���õ�ǰ�ű�·��
set thispath=%~dp0

:: �ж���û��ָ��Ŀ¼
if not exist %spath% (
	echo �ű�����Ŀ¼��û�� [ %spath% ] Ŀ¼
	echo �ű������˳�...
	pause
	exit
)

:: ------------------------------------------------------------------
:: ����ָ��Ŀ¼�µ� Ŀ¼�����ĺ�׺ .bak ���д���
:: .bak ��׺��Ŀ¼��ͨ��Ϊ�Ӳֿ��ʼ��ǰ�ı���
:: 
:: ------------------------------------------------------------------
echo START----------------------------------------------------------------
for /f "usebackq delims=" %%i in (`dir /ad /b/s %root%%spath%\*.bak`) do (
	if %debug%==1  echo fullpath: %%i
	set str=%%i
	REM ·����׺.bak�滻Ϊ��
	REM K:\DevDocCenter\NoSQL\Redis
	set str=!str:.bak=!
	REM ·��ǰ׺�滻Ϊ��
	REM NoSQL\Redis
	set str=!str:%root%%spath%\=!
	REM ���·��
	set RelativePath=!str!
	
	if %debug%==1  echo RelativePath:!RelativePath! 
	if exist "%root%%dpath%\!RelativePath!" (
		echo Ŀ¼�Ѵ���: [ %root%%dpath%\!RelativePath! ] 
		echo.
	) else (
		mkdir "%root%%dpath%\!RelativePath!"  && (			
			echo Ŀ¼�����ɹ�: [ %root%%dpath%\!RelativePath! ]  
			echo.
		) || (			
			echo Ŀ¼����ʧ��: [ %root%%dpath%\!RelativePath! ] 
			echo.
		)	
	)
	
)
echo END------------------------------------------------------------------
pause
exit
