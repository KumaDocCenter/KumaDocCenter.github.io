:: =================================================================== ::
::  ����ǰĿ¼�µ�md�ļ��е�ͼƬ
::  
::  ���ļ��л�ȡͼƬ·����Ϣ�����临�Ƶ��ļ�ͬ����Ŀ¼��
::  
:: ���Ŀ¼�� 
:: ����Ŀ¼�� 
:: 
:: =================================================================== ::
:: �رջ���
@echo off
:: ���Կ���
set debug=0
:: ���������ӳ�
setlocal EnableDelayedExpansion

:: ��־�ļ�������ɾ��
if exist %0.log  del %0.log
:: �����������
call :Start>>%0.log
:: �˳��ű�
exit



:Start
::----------------------------------------------------------------------------
:: ��ע�⡿
REM findstr "\<!\[.*\]\>" Ajaxgaoji.md
REM echo findstr "\<^!\[.*\]\>" Ajaxgaoji.md
:: 
REM findstr "\<^!\[.*\]\>" Ajaxgaoji.md �Ľ������
:: �ļ�ԭʼ����
REM ![1533285162418](1533285162418.png)
REM ![1533285162418](note/1533285162418.png)
REM ![1533285162418](note2\1533285162418.png)
REM ![1533287223815](1533287223815.png) ![a1533287223815](1533287223815.png)
::
:: ʵ������(��������)
REM [1533285162418](1533285162418.png)
REM [1533285162418](note/1533285162418.png)
REM [1533285162418](note2\1533285162418.png)
REM [1533287223815](1533287223815.png) 
REM [a1533287223815](1533287223815.png)
::----------------------------------------------------------------------------

:: EQU - ����  NEQ - ������
:: �����ض����ļ�
for /f "usebackq tokens=*" %%a in (`dir /a/b/s *.md`) do (
	REM [filedir: K:\DevDocCenter\test\doc\md\ ]
	REM [file: K:\DevDocCenter\test\doc\md\Ajaxgaoji.md ]
	REM [filename: Ajaxgaoji ][filenameprefx: Ajaxgaoji.md ]
	if %debug%==1 echo [filedir: %%~dpa ]
	if %debug%==1 echo [file: %%a ]
	if %debug%==1 echo [filename: %%~na ][filenameprefx: %%~nxa ]
	
	REM �ļ�Ŀ¼
	set filedir=%%~dpa
	REM Ŀ��·��
	set dDir=!filedir!%%~na\
	
	call :getYAML  %%a  typora-root-url tr
	REM echo typora-root-url---: %tr%
	
	REM NEQ - ������
	REM Դ·�� sDir
	if "!tr!" NEQ "" (
		REM K:\...\doc\md\asset\
		set sDir=!filedir!!tr!\
	) else (
		REM K:\...\doc\md\
		set sDir=!filedir!
	)
	echo START[ %%~nxa ]--------------------------------------------------
	REM ���ú����������ļ�
	call :get_pic_pathinfo  %%a  cb01
	echo END[ %%~nxa ]----------------------------------------------------
	echo.	
	echo.	
)


GOTO:EOF
:cb01
echo ----------------------------
if %debug%==1 echo FileName---: %FileName%
if %debug%==1 echo FileRpath---: %FileRpath%

:: ����Դ
set s=%sDir%%FileRpath%
REM s : K:\...\doc\md\assets\1533287223815.png
echo s : %s%

:: �ļ����滻Ϊ��
set FileRpath2=!FileRpath:%FileName%=!

:: ����Ŀ��
set d=%dDir%%FileRpath2%
REM d : K:\...\doc\md\Ajaxgaoji\
REM d : K:\...\doc\md\Ajaxgaoji\note\
echo d : %d%

:: �����ļ�
echo xcopy  "%s%"   "%d%"  /Y/Q
xcopy  "%s%"   "%d%"  /Y/Q
echo ----------------------------
if %debug%==1 echo.
GOTO:EOF



:: ==========[Function]================================================================== ::

::::::::����ʾ��:::::::::::
REM call :get_pic_pathinfo  file 

::call :get_pic_pathinfo  Ajaxgaoji.md  cb01
::GOTO:EOF
:::cb01
::echo ----------------------------
::echo FileName---: %FileName%
::echo FileRpath---: %FileRpath%
::echo ----------------------------
::echo.
::GOTO:EOF


GOTO:EOF
:: ================================================== ::
:: �������ƣ�get_pic_pathinfo						  ::
:: �������ܣ���ȡ�ļ���pic��·����Ϣ		 		  ::
:: ����������arg1: �ļ�					 		  	  ::
::  		 	   ֻ�������¸�ʽ����			 	  ::
::  		 	   ![1533285162418](1533285162418.png)::
::           arg2: �ص���������			 			  ::
::           	   ���ڴ���������					  ::
:: ����ֵ��          							      ::
::    �������ݣ�	      			  				  ::
::    %FileName%  �� �ļ���					     	  ::
::   %FileRpath%  �� �ļ����·��					  ::
::        			  					  			  ::
:: ================================================== ::
:get_pic_pathinfo

::----------------------------------------------------------------------------
:: ��ע�⡿
REM findstr "\<^!\[.*\]\>" Ajaxgaoji.md �Ľ������
:: �ļ�ԭʼ����
REM ![1533285162418](1533285162418.png)
REM ![1533285162418](note/1533285162418.png)
REM ![1533285162418](note2\1533285162418.png)
REM ![1533287223815](1533287223815.png) ![a1533287223815](1533287223815.png)
::
:: ʵ������(��������)
REM [1533285162418](1533285162418.png)
REM [1533285162418](note/1533285162418.png)
REM [1533285162418](note2\1533285162418.png)
REM [1533287223815](1533287223815.png) 
REM [a1533287223815](1533287223815.png)
::----------------------------------------------------------------------------
:: ���������ļ�����
for /f "usebackq tokens=*" %%i in (`findstr "\<^!\[.*\]\>" %~1`) do (
	if %debug%==1  echo line: "%%i"
	REM ȥ�ո�
	set str=%%i
	set str=!str: =!
	if %debug%==1  echo lineȥ�ո�"!str!"
	
	REM �����������ݣ� [a1533287223815](1533287223815.png)
	for /f "usebackq tokens=1-2 delims=](" %%a in ('%%i') do (
		if %debug%==1 echo [a: %%a ] [b: %%b ]
		REM echo %%b |findstr "\/" >nul &&( echo �ҵ� /)||( echo δ�ҵ� /)
		REM echo %%b |findstr "\\" >nul &&( echo �ҵ� \)||( echo δ�ҵ� \)
		
		set bstr=%%b
		
		REM ��ȡ ) ������λ��
		call :PosChar !bstr! ^)  bpos
		REM ��ȡ ) ǰ������� bstr
		call :getFileName bstr  0  !bpos!  bstr
			
		REM �Ƿ���� / 
		REM (ֱ�Ӵ���·��)
		echo %%b |findstr "\/" >nul &&( 
			REM ���ڣ��� / �滻Ϊ \			
			set bstr=!bstr:/=\!
		)

		REM �Ƿ���� \  
		REM (�����жϽ��ִ�в�ͬ�Ĵ���ʽ)
		echo !bstr! |findstr "\\" >nul &&( 		
			REM �ļ����·��
			set FileRpath=!bstr!
			
			REM ��ȡ \ ������λ��
			call :PosLastChar !bstr! \  aaa				
			set /A pos=!aaa!+1
			if %debug%==1  echo pos: !pos!	
			REM ��ȡ �ļ���
			call :getFileName bstr !pos! ""  FileName
			
			if %debug%==1 echo FileName: "!FileName!"
			if %debug%==1 echo FileRpath: "!FileRpath!"
		)||(
			REM ������
			REM  �ļ���
			set FileName=!bstr!
			REM �ļ����·��
			set FileRpath=!bstr!
		)
	REM ���ûص�����
	call :%~2  !FileName! !FileRpath!
	)	
)
GOTO:EOF




::::::::����ʾ��:::::::::::
REM call :getFileName  VarName1  pos  VarName2

::call :getFileName bstr !pos!  FileName

GOTO:EOF
:: ================================================== ::
:: �������ƣ�getFileName							  ::
:: �������ܣ���ȡ�ļ���		 						  ::
:: ����������arg1: ������				 		  	  ::
::  		 	   ·���ַ����ı�������	 			  ::
::  		 arg2: ��ʼλ��				 			  ::
::  		 arg3: ����λ��				 			  ::
::  		 arg4: ������				 			  ::
::  		 	   �洢����ı�������	 			  ::
::           							 			  ::
:: ����ֵ��          							      ::
::    %<arg4>%  �� ����ʼλ�ÿ�ʼ��ȡ��ĩβ���ַ���   ::
::        			  					  			  ::
:: ================================================== ::
:getFileName

:: �ַ���ȡ
set %~4=!%~1:~%~2,%~3!

GOTO:EOF




::::::::����ʾ��:::::::::::
REM call :getYAML  file key  VarName

::call :getYAML  Ajaxgaoji.md  typora-root-url tr
::echo typora-root-url---: %tr%

GOTO:EOF
:: ================================================== ::
:: �������ƣ�getYAML							 	  ::
:: �������ܣ���ȡYAML��ָ��key��ֵ		 			  ::
:: ����������arg1: �ļ�					 		  	  ::
::  		 arg2: YAML key			 			 	  ::
::  		 arg3: ������				 			  ::
::  		 	   �洢����ı�������	 			  ::
::           							 			  ::
:: ����ֵ��          							      ::
::    %<arg3>%  �� YAML key��ֵ					      ::
::        			  					  			  ::
:: ================================================== ::
:getYAML
:: �ջ� setlocal ... endlocal
setlocal

:: ����key
set Ykey=%~2

:: EQU - ����  NEQ - ������
:: ��ȡ YAML �е�ָ��key(�磬typora-root-url)��ֵ���洢�ڱ����� mdroot
for /f "usebackq tokens=* skip=1" %%a in ("%~1") do (
	if %debug%==1 echo [Yline: %%a ]
	REM ��ǰ�����ݺ�"---"�Ƚ� 
	if "%%a" EQU "---" (
		REM ��ȣ����˳�
		GOTO gg
	) else (
		REM ����ȣ��������ǰ�����ݣ�������ָ������
		for /f "usebackq tokens=1,* delims=: " %%i in ('%%a') do (
			if %debug%==1 echo [Ykey: %%i ]  [Yvalue: %%j ]
			REM "%%i" == "%Ykey%"
			if "%%i" EQU "%Ykey%" (
				set mdroot=%%j
			)
		)
	)
)
:gg
if %debug%==1 echo %Ykey%: "!mdroot!"
(
endlocal
REM �������
set %~3=%mdroot%
)
GOTO:EOF







:: =================================================================== ::
::  �ַ�������
:: 
:: �������ƣ�PosChar							  	  ::
:: �������ܣ����ַ����в������ַ����״γ���λ��		  ::
:: 
:: �������ƣ�PosLastChar						  	  ::
:: �������ܣ����ַ����в������ַ������һ�γ���λ��	  ::
:: 
:: �������ƣ�StrLen							  		  ::
:: �������ܣ��ַ�������								  ::
:: 
:: ���Ŀ¼��  
:: ����Ŀ¼��   
:: 
:: =================================================================== ::


::::::::����ʾ��:::::::::::
REM call :PosChar  Str SubStr VarName

:: �����ַ���
::set k=speed_dao_mmr
:: ���ú���
::call :PosChar %k% _ aa
::echo ...��0��ʼ����...
::echo �״γ���λ��(5): %aa%


GOTO:EOF
:: ================================================== ::
:: �������ƣ�PosChar							  	  ::
:: �������ܣ����ַ����в������ַ����״γ���λ��		  ::
:: ����������arg1: �ַ���				 		 	  ::
::  		 arg2: ���ַ���				 			  ::
::  		 arg3: ������				 			  ::
::  		 	   �洢����ı�������	 			  ::
::           							 			  ::
:: ����ֵ��          							      ::
::        %<arg3>%  �� ��ȡλ����Ϣ   			  	  ::
::        			   -1����ʾδ�ҵ�   			  ::
:: ================================================== ::
:PosChar
:: �ջ� setlocal ... endlocal
setlocal 

:: ��ȡ���ַ���
set SubStr=
:: �ַ���
set Str=%~1
:: λ�ü���
set F=0
:: ���ý������
set res=-1

:: ��ȡ��������ַ�������
call :StrLen  %~2  SubStrLen
if %debug%==1 echo SubStrLen: %SubStrLen%

::----------------------------------------------------------------
:: ��ע�⡿
:: set SubStr=!Str:~%F%,%SubStrLen%!
:: ��ȡ�ַ����Ͳ���2�Ƚ� ( "%SubStr%"=="%2" )
:: 		ƥ�䵽1���������ò����ؽ��( set res=%F% )���˳�
:: 		δƥ�䣬������ȡ�ַ����������Ƚϣ����ѭ��<ֱ��ƥ���ĩβ>
:: 		1����δƥ��ʱ������Ĭ��ֵ -1 ( set res=-1 )
::	
::----------------------------------------------------------------
:Pos_Begin
:: ��ȡ�ַ���
:: �ӵ�%F%����ʼ����ȡ%SubStrLen%��
set SubStr=!Str:~%F%,%SubStrLen%!

:: ���SubStrδ���壬�� SubStr=��ʱ���˳�
if not defined SubStr goto :Pos_End

:: ��ȡ���ַ����ʹ������2�Ƚ� 
if "%SubStr%"=="%~2" (
    REM ��ȣ�������res=�������˳�
	set res=%F%
    goto :Pos_End
) else (
    REM ����ȣ�����+1��ѭ��
	set /a F=%F%+1
    goto :Pos_begin
)
:Pos_End
(
endlocal
REM �������
set %~3=%res%
)
GOTO:EOF


::::::::����ʾ��:::::::::::
REM :PosLastChar Str SubStr VarName

:: �����ַ���
::set k=speed_dao_mmr
:: ���ú���
::call :PosLastChar %k% _ bb
::echo ...��0��ʼ����...
::echo ���һ�γ���λ��(9)��%bb%



GOTO:EOF
:: ================================================== ::
:: �������ƣ�PosLastChar						  	  ::
:: �������ܣ����ַ����в������ַ������һ�γ���λ��	  ::
:: ����������arg1: �ַ���				 		 	  ::
::  		 arg2: ���ַ���				 			  ::
::  		 arg3: ������				 			  ::
::  		 	   �洢����ı�������	 			  ::
::           							 			  ::
:: ����ֵ��          							      ::
::        %<arg3>%  �� ��ȡλ����Ϣ   			  	  ::
::        			   -1����ʾδ�ҵ�   			  ::
:: ================================================== ::
:PosLastChar
:: �ջ� setlocal ... endlocal
setlocal 

:: ��ȡ���ַ���
set SubStr=
:: �ַ���
set Str=%~1
:: λ�ü���
set F=0
:: ���ý������
set res=-1

:: ��ȡ��������ַ�������
call :StrLen  %~2  SubStrLen
if %debug%==1 echo SubStrLen: %SubStrLen%

::----------------------------------------------------------------
:: ��ע�⡿
:: set SubStr=!Str:~%F%,%SubStrLen%!
:: ��ȡ�ַ����Ͳ���2�Ƚ� ( "%SubStr%"=="%2" )
:: 		ƥ�䵽�����ý��( set res=%F% )��������ȡ�ַ����������Ƚϣ����ѭ��<ֱ��ĩβ>
:: 		δƥ�䣬������ȡ�ַ����������Ƚϣ����ѭ��<ֱ��ƥ���ĩβ>
::		���ս��Ϊ���ƥ���λ�á�
::		1����δƥ��ʱ������Ĭ��ֵ -1 ( set res=-1 )
::	
::----------------------------------------------------------------
:PosLast_Begin
:: ��ȡ�ַ���
:: �ӵ�%F%����ʼ����ȡ%SubStrLen%��
set SubStr=!Str:~%F%,%SubStrLen%!
:: ���SubStrδ���壬�� SubStr=��ʱ���˳�
if not defined SubStr goto :PosLast_End
:: ��ȡ���ַ����ʹ������2�Ƚ� 
if "%SubStr%"=="%~2" (
    REM ��ȣ�������res=����������+1��Ȼ��ѭ��
	set res=%F%
    set /a F=%F%+1
    goto :PosLast_Begin
) else (
    REM ��ȣ�����+1��Ȼ��ѭ��
	set /a F=%F%+1
    goto :PosLast_Begin
)
:PosLast_End
(
endlocal
REM �������
set %~3=%res%
)
GOTO:EOF


::::::::����ʾ��:::::::::::
REM call :StrLen  Str  VarName

::call :StrLen  abc  strl
::echo abc ���ȣ� %strl%
::echo abc ����zero�� %strlzero%

GOTO:EOF
:: ================================================== ::
:: �������ƣ�StrLen							  		  ::
:: �������ܣ��ַ�������								  ::
:: ����������arg1: �ַ���				 		 	  ::
::  		 arg2: ������				 			  ::
::  		 	   �洢����ı�������	 			  ::
::           							 			  ::
:: ����ֵ��          							      ::
::        %<arg2>%  �� ��ȡ����(ʵ�ʳ���)  			  ::
::    %<arg2zero>%  �� ��ȡ����(����-1)		  	 	  ::
:: ================================================== ::
:StrLen
:: �ջ� setlocal ... endlocal
setlocal  
:: �ַ���
set str=%~1

:strLen_Loop
:: EQU - ����  NEQ - ������
:: �� %len% ���ַ���ʼ��ȡ�����
:: ��ʼʱ��û������len��������Ϊ�����ַ���
if "!str:~%len%!" NEQ "" (
	REM �����ڿ�ʱ��len+1 ��ѭ��
	set /A len+=1
	goto :strLen_Loop
)
(
endlocal
REM �������
set %~2=%len%
set /A %~2zero=%len%-1
)
GOTO:EOF

:: ==========[Function]================================================================== ::

