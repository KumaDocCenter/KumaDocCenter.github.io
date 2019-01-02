:: =================================================================== ::
::  处理当前目录下的md文件中的图片
::  
::  从文件中获取图片路径信息，将其复制到文件同名的目录下
::  
:: 存放目录： 
:: 运行目录： 
:: 
:: =================================================================== ::
:: 关闭回显
@echo off
:: 调试开关
set debug=0
:: 开启变量延迟
setlocal EnableDelayedExpansion

:: 日志文件存在则删除
if exist %0.log  del %0.log
:: 调用主程序块
call :Start>>%0.log
:: 退出脚本
exit



:Start
::----------------------------------------------------------------------------
:: 【注解】
REM findstr "\<!\[.*\]\>" Ajaxgaoji.md
REM echo findstr "\<^!\[.*\]\>" Ajaxgaoji.md
:: 
REM findstr "\<^!\[.*\]\>" Ajaxgaoji.md 的结果如下
:: 文件原始数据
REM ![1533285162418](1533285162418.png)
REM ![1533285162418](note/1533285162418.png)
REM ![1533285162418](note2\1533285162418.png)
REM ![1533287223815](1533287223815.png) ![a1533287223815](1533287223815.png)
::
:: 实际数据(！不存在)
REM [1533285162418](1533285162418.png)
REM [1533285162418](note/1533285162418.png)
REM [1533285162418](note2\1533285162418.png)
REM [1533287223815](1533287223815.png) 
REM [a1533287223815](1533287223815.png)
::----------------------------------------------------------------------------

:: EQU - 等于  NEQ - 不等于
:: 遍历特定的文件
for /f "usebackq tokens=*" %%a in (`dir /a/b/s *.md`) do (
	REM [filedir: K:\DevDocCenter\test\doc\md\ ]
	REM [file: K:\DevDocCenter\test\doc\md\Ajaxgaoji.md ]
	REM [filename: Ajaxgaoji ][filenameprefx: Ajaxgaoji.md ]
	if %debug%==1 echo [filedir: %%~dpa ]
	if %debug%==1 echo [file: %%a ]
	if %debug%==1 echo [filename: %%~na ][filenameprefx: %%~nxa ]
	
	REM 文件目录
	set filedir=%%~dpa
	REM 目标路径
	set dDir=!filedir!%%~na\
	
	call :getYAML  %%a  typora-root-url tr
	REM echo typora-root-url---: %tr%
	
	REM NEQ - 不等于
	REM 源路径 sDir
	if "!tr!" NEQ "" (
		REM K:\...\doc\md\asset\
		set sDir=!filedir!!tr!\
	) else (
		REM K:\...\doc\md\
		set sDir=!filedir!
	)
	echo START[ %%~nxa ]--------------------------------------------------
	REM 调用函数处理单个文件
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

:: 设置源
set s=%sDir%%FileRpath%
REM s : K:\...\doc\md\assets\1533287223815.png
echo s : %s%

:: 文件名替换为空
set FileRpath2=!FileRpath:%FileName%=!

:: 设置目标
set d=%dDir%%FileRpath2%
REM d : K:\...\doc\md\Ajaxgaoji\
REM d : K:\...\doc\md\Ajaxgaoji\note\
echo d : %d%

:: 复制文件
echo xcopy  "%s%"   "%d%"  /Y/Q
xcopy  "%s%"   "%d%"  /Y/Q
echo ----------------------------
if %debug%==1 echo.
GOTO:EOF



:: ==========[Function]================================================================== ::

::::::::调用示例:::::::::::
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
:: 函数名称：get_pic_pathinfo						  ::
:: 函数功能：获取文件中pic的路径信息		 		  ::
:: 函数参数：arg1: 文件					 		  	  ::
::  		 	   只解析如下格式数据			 	  ::
::  		 	   ![1533285162418](1533285162418.png)::
::           arg2: 回调函数名称			 			  ::
::           	   用于处理单个数据					  ::
:: 返回值：          							      ::
::    单个数据：	      			  				  ::
::    %FileName%  ： 文件名					     	  ::
::   %FileRpath%  ： 文件相对路径					  ::
::        			  					  			  ::
:: ================================================== ::
:get_pic_pathinfo

::----------------------------------------------------------------------------
:: 【注解】
REM findstr "\<^!\[.*\]\>" Ajaxgaoji.md 的结果如下
:: 文件原始数据
REM ![1533285162418](1533285162418.png)
REM ![1533285162418](note/1533285162418.png)
REM ![1533285162418](note2\1533285162418.png)
REM ![1533287223815](1533287223815.png) ![a1533287223815](1533287223815.png)
::
:: 实际数据(！不存在)
REM [1533285162418](1533285162418.png)
REM [1533285162418](note/1533285162418.png)
REM [1533285162418](note2\1533285162418.png)
REM [1533287223815](1533287223815.png) 
REM [a1533287223815](1533287223815.png)
::----------------------------------------------------------------------------
:: 遍历单个文件内容
for /f "usebackq tokens=*" %%i in (`findstr "\<^!\[.*\]\>" %~1`) do (
	if %debug%==1  echo line: "%%i"
	REM 去空格
	set str=%%i
	set str=!str: =!
	if %debug%==1  echo line去空格："!str!"
	
	REM 解析单个数据： [a1533287223815](1533287223815.png)
	for /f "usebackq tokens=1-2 delims=](" %%a in ('%%i') do (
		if %debug%==1 echo [a: %%a ] [b: %%b ]
		REM echo %%b |findstr "\/" >nul &&( echo 找到 /)||( echo 未找到 /)
		REM echo %%b |findstr "\\" >nul &&( echo 找到 \)||( echo 未找到 \)
		
		set bstr=%%b
		
		REM 获取 ) 最后出现位置
		call :PosChar !bstr! ^)  bpos
		REM 获取 ) 前面的内容 bstr
		call :getFileName bstr  0  !bpos!  bstr
			
		REM 是否存在 / 
		REM (直接处理路径)
		echo %%b |findstr "\/" >nul &&( 
			REM 存在，则将 / 替换为 \			
			set bstr=!bstr:/=\!
		)

		REM 是否存在 \  
		REM (根据判断结果执行不同的处理方式)
		echo !bstr! |findstr "\\" >nul &&( 		
			REM 文件相对路径
			set FileRpath=!bstr!
			
			REM 获取 \ 最后出现位置
			call :PosLastChar !bstr! \  aaa				
			set /A pos=!aaa!+1
			if %debug%==1  echo pos: !pos!	
			REM 获取 文件名
			call :getFileName bstr !pos! ""  FileName
			
			if %debug%==1 echo FileName: "!FileName!"
			if %debug%==1 echo FileRpath: "!FileRpath!"
		)||(
			REM 不存在
			REM  文件名
			set FileName=!bstr!
			REM 文件相对路径
			set FileRpath=!bstr!
		)
	REM 调用回调函数
	call :%~2  !FileName! !FileRpath!
	)	
)
GOTO:EOF




::::::::调用示例:::::::::::
REM call :getFileName  VarName1  pos  VarName2

::call :getFileName bstr !pos!  FileName

GOTO:EOF
:: ================================================== ::
:: 函数名称：getFileName							  ::
:: 函数功能：获取文件名		 						  ::
:: 函数参数：arg1: 变量名				 		  	  ::
::  		 	   路径字符串的变量名称	 			  ::
::  		 arg2: 起始位置				 			  ::
::  		 arg3: 结束位置				 			  ::
::  		 arg4: 变量名				 			  ::
::  		 	   存储结果的变量名称	 			  ::
::           							 			  ::
:: 返回值：          							      ::
::    %<arg4>%  ： 从起始位置开始截取到末尾的字符串   ::
::        			  					  			  ::
:: ================================================== ::
:getFileName

:: 字符截取
set %~4=!%~1:~%~2,%~3!

GOTO:EOF




::::::::调用示例:::::::::::
REM call :getYAML  file key  VarName

::call :getYAML  Ajaxgaoji.md  typora-root-url tr
::echo typora-root-url---: %tr%

GOTO:EOF
:: ================================================== ::
:: 函数名称：getYAML							 	  ::
:: 函数功能：获取YAML中指定key的值		 			  ::
:: 函数参数：arg1: 文件					 		  	  ::
::  		 arg2: YAML key			 			 	  ::
::  		 arg3: 变量名				 			  ::
::  		 	   存储结果的变量名称	 			  ::
::           							 			  ::
:: 返回值：          							      ::
::    %<arg3>%  ： YAML key的值					      ::
::        			  					  			  ::
:: ================================================== ::
:getYAML
:: 闭环 setlocal ... endlocal
setlocal

:: 设置key
set Ykey=%~2

:: EQU - 等于  NEQ - 不等于
:: 获取 YAML 中的指定key(如，typora-root-url)的值，存储在变量名 mdroot
for /f "usebackq tokens=* skip=1" %%a in ("%~1") do (
	if %debug%==1 echo [Yline: %%a ]
	REM 当前行内容和"---"比较 
	if "%%a" EQU "---" (
		REM 相等，则退出
		GOTO gg
	) else (
		REM 不相等，则解析当前行内容，并设置指定变量
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
REM 输出变量
set %~3=%mdroot%
)
GOTO:EOF







:: =================================================================== ::
::  字符串处理
:: 
:: 函数名称：PosChar							  	  ::
:: 函数功能：在字符串中查找子字符串首次出现位置		  ::
:: 
:: 函数名称：PosLastChar						  	  ::
:: 函数功能：在字符串中查找子字符串最后一次出现位置	  ::
:: 
:: 函数名称：StrLen							  		  ::
:: 函数功能：字符串长度								  ::
:: 
:: 存放目录：  
:: 运行目录：   
:: 
:: =================================================================== ::


::::::::调用示例:::::::::::
REM call :PosChar  Str SubStr VarName

:: 设置字符串
::set k=speed_dao_mmr
:: 调用函数
::call :PosChar %k% _ aa
::echo ...从0开始计算...
::echo 首次出现位置(5): %aa%


GOTO:EOF
:: ================================================== ::
:: 函数名称：PosChar							  	  ::
:: 函数功能：在字符串中查找子字符串首次出现位置		  ::
:: 函数参数：arg1: 字符串				 		 	  ::
::  		 arg2: 子字符串				 			  ::
::  		 arg3: 变量名				 			  ::
::  		 	   存储结果的变量名称	 			  ::
::           							 			  ::
:: 返回值：          							      ::
::        %<arg3>%  ： 获取位置信息   			  	  ::
::        			   -1，表示未找到   			  ::
:: ================================================== ::
:PosChar
:: 闭环 setlocal ... endlocal
setlocal 

:: 截取的字符串
set SubStr=
:: 字符串
set Str=%~1
:: 位置计数
set F=0
:: 设置结果变量
set res=-1

:: 获取传入的子字符串长度
call :StrLen  %~2  SubStrLen
if %debug%==1 echo SubStrLen: %SubStrLen%

::----------------------------------------------------------------
:: 【注解】
:: set SubStr=!Str:~%F%,%SubStrLen%!
:: 截取字符串和参数2比较 ( "%SubStr%"=="%2" )
:: 		匹配到1个，则设置并返回结果( set res=%F% )并退出
:: 		未匹配，继续截取字符串，继续比较，如此循环<直到匹配或到末尾>
:: 		1个都未匹配时，返回默认值 -1 ( set res=-1 )
::	
::----------------------------------------------------------------
:Pos_Begin
:: 截取字符串
:: 从第%F%个开始，截取%SubStrLen%个
set SubStr=!Str:~%F%,%SubStrLen%!

:: 如果SubStr未定义，即 SubStr=空时，退出
if not defined SubStr goto :Pos_End

:: 截取的字符串和传入参数2比较 
if "%SubStr%"=="%~2" (
    REM 相等，则设置res=计数并退出
	set res=%F%
    goto :Pos_End
) else (
    REM 不相等，计数+1并循环
	set /a F=%F%+1
    goto :Pos_begin
)
:Pos_End
(
endlocal
REM 输出变量
set %~3=%res%
)
GOTO:EOF


::::::::调用示例:::::::::::
REM :PosLastChar Str SubStr VarName

:: 设置字符串
::set k=speed_dao_mmr
:: 调用函数
::call :PosLastChar %k% _ bb
::echo ...从0开始计算...
::echo 最后一次出现位置(9)：%bb%



GOTO:EOF
:: ================================================== ::
:: 函数名称：PosLastChar						  	  ::
:: 函数功能：在字符串中查找子字符串最后一次出现位置	  ::
:: 函数参数：arg1: 字符串				 		 	  ::
::  		 arg2: 子字符串				 			  ::
::  		 arg3: 变量名				 			  ::
::  		 	   存储结果的变量名称	 			  ::
::           							 			  ::
:: 返回值：          							      ::
::        %<arg3>%  ： 获取位置信息   			  	  ::
::        			   -1，表示未找到   			  ::
:: ================================================== ::
:PosLastChar
:: 闭环 setlocal ... endlocal
setlocal 

:: 截取的字符串
set SubStr=
:: 字符串
set Str=%~1
:: 位置计数
set F=0
:: 设置结果变量
set res=-1

:: 获取传入的子字符串长度
call :StrLen  %~2  SubStrLen
if %debug%==1 echo SubStrLen: %SubStrLen%

::----------------------------------------------------------------
:: 【注解】
:: set SubStr=!Str:~%F%,%SubStrLen%!
:: 截取字符串和参数2比较 ( "%SubStr%"=="%2" )
:: 		匹配到，设置结果( set res=%F% )，继续截取字符串，继续比较，如此循环<直到末尾>
:: 		未匹配，继续截取字符串，继续比较，如此循环<直到匹配或到末尾>
::		最终结果为最后匹配的位置。
::		1个都未匹配时，返回默认值 -1 ( set res=-1 )
::	
::----------------------------------------------------------------
:PosLast_Begin
:: 截取字符串
:: 从第%F%个开始，截取%SubStrLen%个
set SubStr=!Str:~%F%,%SubStrLen%!
:: 如果SubStr未定义，即 SubStr=空时，退出
if not defined SubStr goto :PosLast_End
:: 截取的字符串和传入参数2比较 
if "%SubStr%"=="%~2" (
    REM 相等，则设置res=计数，计数+1，然后循环
	set res=%F%
    set /a F=%F%+1
    goto :PosLast_Begin
) else (
    REM 相等，计数+1，然后循环
	set /a F=%F%+1
    goto :PosLast_Begin
)
:PosLast_End
(
endlocal
REM 输出变量
set %~3=%res%
)
GOTO:EOF


::::::::调用示例:::::::::::
REM call :StrLen  Str  VarName

::call :StrLen  abc  strl
::echo abc 长度： %strl%
::echo abc 长度zero： %strlzero%

GOTO:EOF
:: ================================================== ::
:: 函数名称：StrLen							  		  ::
:: 函数功能：字符串长度								  ::
:: 函数参数：arg1: 字符串				 		 	  ::
::  		 arg2: 变量名				 			  ::
::  		 	   存储结果的变量名称	 			  ::
::           							 			  ::
:: 返回值：          							      ::
::        %<arg2>%  ： 获取长度(实际长度)  			  ::
::    %<arg2zero>%  ： 获取长度(长度-1)		  	 	  ::
:: ================================================== ::
:StrLen
:: 闭环 setlocal ... endlocal
setlocal  
:: 字符串
set str=%~1

:strLen_Loop
:: EQU - 等于  NEQ - 不等于
:: 从 %len% 个字符开始截取到最后
:: 开始时，没有设置len变量，则为整个字符串
if "!str:~%len%!" NEQ "" (
	REM 不等于空时，len+1 并循环
	set /A len+=1
	goto :strLen_Loop
)
(
endlocal
REM 输出变量
set %~2=%len%
set /A %~2zero=%len%-1
)
GOTO:EOF

:: ==========[Function]================================================================== ::

