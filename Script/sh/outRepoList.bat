:: ============================================================================= ::
:: ��������Ӳֿ��б�
::
:: ���˽ű���ScriptĿ¼һ���Ƶ��Ӳֿ��Ŀ¼��
:: ע�� ͨ��������˽ű�������ϻ�ɾ������
::
:: ���Ŀ¼�� ./Script/sh 
:: ����Ŀ¼�� ./ 
:: 
:: ============================================================================= ::

:::::::::::::::: ����Ԥ���� ::::::::::::::::
:: �رջ���
@echo off
:: ���Կ���
set debug=0
:: ���������ӳ�
setlocal EnableDelayedExpansion
:: ��ǰ�ļ���
set this=%0
:: �Ƿ�Ϊ����ļ�
set is_index=0

:: cd��ת����Ŀ¼(��Ϊ��ǰ���Ŀ¼��./Script/sh��������Ҫ����)
cd %~dp0
cd..
cd..
:: ���ø�Ŀ¼·��
set root=%cd%
:: ���õ�ǰ�ű�·��
set thispath=%~dp0



if %debug%==1 echo ------------------------ ��������ʱ���ʱ���  ----------------------

:: ���ڷָ���
set delim=-

:: ���ڴ���( 2018-12-10 )
for /f "tokens=1-4  delims=/ " %%a in ("%date%") do (
	set _de=%%a%delim%%%b%delim%%%c
	set de=%%a%%b%%c
	set week=%%d
)
:: ʱ�䴦��( 21:43:58 )
for /f "tokens=1-4  delims=:." %%a in ("%time%") do (
	set _ti=%%a:%%b:%%c
	set ti=%%a%%b%%c
)

:: ��ǰ����ʱ��( 2018-12-10 21:43:58 )
set "datetime=%_de% %_ti%"
echo ����ʱ�䣺"%datetime%"

:: ����ʱ�� ��( 20181207180016 )
set deti=%de%%ti%
:::: ȥ�����пո�
set timestamp=%deti: =%
echo ʱ�����"%timestamp%"
if %debug%==1 echo ------------------------ ��������ʱ���ʱ���  ----------------------
:::::::::::::::: ����Ԥ���� ::::::::::::::::

:: ���ö�ȡ·��
set spath=data\SubRepo\conf\staged
:: ���ô������·��
set dpath=data\SubRepo\conf\ok
:: .Repo �����ļ����·��
set RepoOut=data\SubRepo\conf\staged

call :outRepoList  %spath%  %dpath%


:: ==========[Function]================================================================== ::
::outRepoList_test
:::::::: ����ʾ�� ::::::::
::set spath=data\SubRepo\conf\staged
::set dpath=data\SubRepo\conf\ok

::call :outRepoList  %spath%  %dpath%


GOTO:EOF
:: ================================================== ::
:: �������ƣ�outRepoList							  ::
:: �������ܣ�����Ӳֿ��б�							  ::
:: ����������arg1: �ļ�Դ·�� 						  ::
::           	   ÿ��һ��key=value	 			  ::
::  			   .add      �����ģ��				  ::
::  			   .init	 ��ʼ����ģ��			  ::
:: 				   .update	 ������ģ��				  ::
::  			   .del		 ɾ����ģ��		 		  ::
::           arg2: �ļ�Ŀ��·�� 					  ::
::           	   ��Դ·���ļ���������Ƶ���	 	  ::
:: ����ֵ�� 									 	  ::
:: 		      						 				  ::
:: ================================================== ::
:outRepoList
if %debug%==1 echo Localtion: %this%: %~0 .................
if %debug%==1 echo ---arg0: %~0 
if %debug%==1 echo ---arg1: %~1 
if %debug%==1 echo ---arg2: %~2 
if %debug%==1 echo ---arg3: %~3 
if %debug%==1 echo ---arg4: %~4 
if %debug%==1 echo ---arg5: %~5
if %debug%==1 echo ---arg6: %~6 
if %debug%==1 echo ---arg7: %~7 
if %debug%==1 echo ---arg8: %~8
if %debug%==1 echo ---arg9: %~9
if %debug%==1 echo Localtion: %this%: %~0 .................

if %debug%==1 echo spath: %cd%\%~1
if %debug%==1 echo dpath: %cd%\%~2

:: Ŀ¼�����ڣ��򴴽�
IF NOT EXIST "%cd%\%~2" ( mkdir "%cd%\%~2" )

if %debug%==1 set f=0
:: ----------------------------------------------------------------
:: �����͡�
:: ʾ�����ݣ�
:: 
:: ����ָ��Ŀ¼�µ��ļ� 
:: for /f "usebackq tokens=* delims=" %%i in (`dir %cd%\%~1\*.add  /a-d/s/b`) do (...)
:: 		delims=      ���ָ���ΪĬ�ϣ�����
:: 		tokens=*     : ��һ������Ϊ����
:: 		%%i			 ��for���ñ������ֱ���յ�1������
:: 		usebackq     : ��� in (``) �еķ����ţ������з����Ű���������
::
:: dir %cd%\%~1\*.add  /a-d/s/b
:: �г�ָ��Ŀ¼�������ļ�����
:: K:\Script\sh\a.add
:: K:\Script\sh\b.add
:: K:\Script\sh\c.add
:: 
:: 
:: ��ȡÿ���ļ��е����ã�key=value
:: for /f "usebackq eol=# tokens=1,2 delims==" %%a in ( "%%i" ) do (...)
:: 		delims==     ���ָ���Ϊ =
:: 		tokens=1,2   : ���ݷָ�������ݸ�1��2������
:: 		%%a,%%b		 ��for���ñ��������ղ�����%%a(key),%%b(value)
:: 		usebackq     : ��� in ("") �еķ����ţ�˫����""�����ļ��� 
:: 		eol=#	     : ����#��ͷ���� 
::
::	��Ҫ����ȡÿ���ļ��е����ã������ļ���׺���ò�ͬ�ĺ���������
::   ��׺   		����
::  .add     	 �����ģ��	
::  .init		 ��ʼ����ģ��
::  .update		 ������ģ��
::  .del		 ɾ����ģ��
:: ----------------------------------------------------------------
for /f "usebackq tokens=* delims=" %%i in (`dir %cd%\%~1\*.add  /a-d/s/b`) do (
	if %debug%==1 echo -------FileCount��!f! ----------------	
	if %debug%==1 echo [i: %%i ][prefx: %%~xi ]
	
	if %debug%==1 set v=0
	for /f "usebackq eol=# tokens=1,2 delims==" %%a in ( "%%i" ) do (
		if %debug%==1 echo -------VarCount��!v! ---------
		if %debug%==1 echo [a: %%a ][b: %%b  ]
		
		:: ���ñ���   EQU - ����
		if "%%a" EQU "branchs" (
			set branchs=%%b
			for /f "usebackq eol=# tokens=1-6 delims=:" %%i in ( '%%b' ) do (
				set branchs_a=%%i
				set branchs_b=%%j
				set branchs_c=%%k
				set branchs_d=%%l
				set branchs_e=%%m
				set branchs_f=%%n
			)			
		) else (
			set %%a=%%b
		)
		
		if %debug%==1 set %%a
		if %debug%==1 echo -------VarCount��!v! ---------
		if %debug%==1 set /a v+=1
	)
	if %debug%==1 set branchs
	
	
	set bstr_a=
	set bstr_b=
	REM NEQ - ������ 
	if "!branchs_a!" NEQ "" (
		set bstr_a=[!branchs_a!](https://github.com/KumaDocCenter/!name!/tree/!branchs_a!^)
	)
	if "!branchs_b!" NEQ "" (
		set bstr_b=[!branchs_b!](https://github.com/KumaDocCenter/!name!/tree/!branchs_b!^)
	)
	
	REM ���md�ļ�
	echo ^* [!name!](!git!^) >>RepoList.md
	echo   ^* ��ʼ��ʱ�䣺 !init_date!  >>RepoList.md
	echo   ^* ��ʼ��֧�� !bstr_a!   !bstr_b!  >>RepoList.md
	
	REM ����Ӳֿ������ļ�
	REM call  :outRepoList_Config  !name!   "!init_date!"  !RepoOut!  !branch!  !branchs!

	REM �ƶ��ļ�
	move /Y %%i  %cd%\%~2
		
	if %debug%==1 echo -------FileCount��!f! ----------------
	if %debug%==1 set /a f+=1
)
GOTO:EOF
:: ==========[Function]================================================================== ::




:: ==========[Function]================================================================== ::
::outRepoList_Config_test
:::::::: ����ʾ�� ::::::::
:: call  :outRepoList_Config  %dirname%  "%datetime%"  data\Repo\conf\staged  %branch%  %branchs%

GOTO:EOF
:: ================================================== ::
:: �������ƣ�outRepoList_Config					 	  ::
:: �������ܣ�����Ӳֿ������ļ�						  ::
:: ����������arg1: �Ӳֿ���			 	  			  ::
::                 �Ӳֿ����·��			 		  ::
::           arg2: ����ʱ��						  	  ::
::           arg3: ���Ŀ¼					  	 	  ::
::                 ���·��(���������Ŀ¼ ./ ) 	  ::
::                 �� data\Repo\conf\staged 		  ::
::                 ����·��						 	  ::
::                 �� K:\data\Repo\conf\staged 		  ::
::           arg4: ��֧					  	 	 	  ::
::           arg5: ���з�֧					  	 	  ::
::           arg6: �ű�1					  	 	  ::
::           arg7: �ű�2					  	 	  ::
:: ����ֵ�� 									 	  ::
:: 													  ::
:: ================================================== ::
:outRepoList_Config

::::::::::��������::::::::::::::::
set "_dirname=%~1"
set "_datetime=%~2"
set "_path=%~3"
set "_type=Repo"
::::::::::��������::::::::::::::::

:: Ŀ¼�����ڣ��򴴽�
if not exist  %_path%  mkdir %_path%

::::::::::��������::::::::::::::::
set "dn=%_path%\%_dirname%.%_type%"
set git=https://github.com/KumaDocCenter/%_dirname%.git
set name=%_dirname%
set branch=%~4
set branchs=%~5
set "init_date=%_datetime%"
set sh=%~6
set sh2=%~7

REM %~dp0 : K:\...\Script\sh\

::::::::::��������::::::::::::::::

if %debug%==1 echo ------------------------ ����Ӳֿ������ļ�  ------------------------
echo ###################################################### >%dn%
echo #  �Ӳֿ������������ļ� >>%dn%
echo #  ��׺   		���� >>%dn%
echo # .Repo        ��ʼ��������Ӳֿ� >>%dn%	
echo #------------------------------------------------ >>%dn%
echo #  git        :  git ��ַ >>%dn%
echo #  name       :  �Ӳֿ����� >>%dn%
echo #  branch     :  �Ӳֿ��֧ >>%dn%
echo #  branchs    :  �Ӳֿ����з�֧  >>%dn%
echo #  init_date  :  �Ӳֿ��ʼ��ʱ�� >>%dn%
echo #  sh  	   	  :  ��ִ�еĶ���ű� ·�� >>%dn%
echo #  sh2  	  :  ��ִ�еĶ���ű� ·�� >>%dn%
echo ###################################################### >>%dn%
echo git=%git%>>%dn%
echo name=%name%>>%dn%
echo branch=%branch%>>%dn%
echo branchs=%branchs%>>%dn%
echo init_date=%init_date%>>%dn%
echo sh=%sh%>>%dn%
echo sh2=%sh2%>>%dn%

echo. 
echo �����Ӳֿ�������ļ�������
echo [ %dn% ]
echo.
if %debug%==1 echo ------------------------ ����Ӳֿ������ļ�  ------------------------
GOTO:EOF
:: ==========[Function]================================================================== ::


