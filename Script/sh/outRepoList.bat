:: ============================================================================= ::
:: 输出所有子仓库列表
::
:: 将此脚本和Script目录一起复制到子仓库根目录。
:: 注： 通常情况，此脚本运行完毕会删除自身
::
:: 存放目录： ./Script/sh 
:: 运行目录： ./ 
:: 
:: ============================================================================= ::

:::::::::::::::: 变量预处理 ::::::::::::::::
:: 关闭回显
@echo off
:: 调试开关
set debug=0
:: 开启变量延迟
setlocal EnableDelayedExpansion
:: 当前文件名
set this=%0
:: 是否为入口文件
set is_index=0

:: cd跳转到根目录(因为当前存放目录：./Script/sh，所以需要更改)
cd %~dp0
cd..
cd..
:: 设置根目录路径
set root=%cd%
:: 设置当前脚本路径
set thispath=%~dp0



if %debug%==1 echo ------------------------ 简易日期时间和时间戳  ----------------------

:: 日期分隔符
set delim=-

:: 日期处理( 2018-12-10 )
for /f "tokens=1-4  delims=/ " %%a in ("%date%") do (
	set _de=%%a%delim%%%b%delim%%%c
	set de=%%a%%b%%c
	set week=%%d
)
:: 时间处理( 21:43:58 )
for /f "tokens=1-4  delims=:." %%a in ("%time%") do (
	set _ti=%%a:%%b:%%c
	set ti=%%a%%b%%c
)

:: 当前日期时间( 2018-12-10 21:43:58 )
set "datetime=%_de% %_ti%"
echo 日期时间："%datetime%"

:: 日期时间 戳( 20181207180016 )
set deti=%de%%ti%
:::: 去除所有空格
set timestamp=%deti: =%
echo 时间戳："%timestamp%"
if %debug%==1 echo ------------------------ 简易日期时间和时间戳  ----------------------
:::::::::::::::: 变量预处理 ::::::::::::::::

:: 配置读取路径
set spath=data\SubRepo\conf\staged
:: 配置处理完成路径
set dpath=data\SubRepo\conf\ok
:: .Repo 配置文件输出路径
set RepoOut=data\SubRepo\conf\staged

call :outRepoList  %spath%  %dpath%


:: ==========[Function]================================================================== ::
::outRepoList_test
:::::::: 调用示例 ::::::::
::set spath=data\SubRepo\conf\staged
::set dpath=data\SubRepo\conf\ok

::call :outRepoList  %spath%  %dpath%


GOTO:EOF
:: ================================================== ::
:: 函数名称：outRepoList							  ::
:: 函数功能：输出子仓库列表							  ::
:: 函数参数：arg1: 文件源路径 						  ::
::           	   每行一个key=value	 			  ::
::  			   .add      添加子模块				  ::
::  			   .init	 初始化子模块			  ::
:: 				   .update	 更新子模块				  ::
::  			   .del		 删除子模块		 		  ::
::           arg2: 文件目标路径 					  ::
::           	   将源路径文件处理完后复制到此	 	  ::
:: 返回值： 									 	  ::
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

:: 目录不存在，则创建
IF NOT EXIST "%cd%\%~2" ( mkdir "%cd%\%~2" )

if %debug%==1 set f=0
:: ----------------------------------------------------------------
:: 【解释】
:: 示例数据：
:: 
:: 遍历指定目录下的文件 
:: for /f "usebackq tokens=* delims=" %%i in (`dir %cd%\%~1\*.add  /a-d/s/b`) do (...)
:: 		delims=      ：分隔符为默认，换行
:: 		tokens=*     : 将一整行作为参数
:: 		%%i			 ：for内置变量，分别接收第1个参数
:: 		usebackq     : 配合 in (``) 中的反引号，能运行反引号包裹的命令
::
:: dir %cd%\%~1\*.add  /a-d/s/b
:: 列出指定目录下所有文件，如
:: K:\Script\sh\a.add
:: K:\Script\sh\b.add
:: K:\Script\sh\c.add
:: 
:: 
:: 读取每个文件中的配置：key=value
:: for /f "usebackq eol=# tokens=1,2 delims==" %%a in ( "%%i" ) do (...)
:: 		delims==     ：分隔符为 =
:: 		tokens=1,2   : 传递分隔后的数据给1，2个参数
:: 		%%a,%%b		 ：for内置变量，接收参数。%%a(key),%%b(value)
:: 		usebackq     : 配合 in ("") 中的反引号，双引号""代表文件名 
:: 		eol=#	     : 忽略#开头的行 
::
::	主要：读取每个文件中的配置，根据文件后缀调用不同的函数来处理
::   后缀   		作用
::  .add     	 添加子模块	
::  .init		 初始化子模块
::  .update		 更新子模块
::  .del		 删除子模块
:: ----------------------------------------------------------------
for /f "usebackq tokens=* delims=" %%i in (`dir %cd%\%~1\*.add  /a-d/s/b`) do (
	if %debug%==1 echo -------FileCount：!f! ----------------	
	if %debug%==1 echo [i: %%i ][prefx: %%~xi ]
	
	if %debug%==1 set v=0
	for /f "usebackq eol=# tokens=1,2 delims==" %%a in ( "%%i" ) do (
		if %debug%==1 echo -------VarCount：!v! ---------
		if %debug%==1 echo [a: %%a ][b: %%b  ]
		
		:: 设置变量   EQU - 等于
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
		if %debug%==1 echo -------VarCount：!v! ---------
		if %debug%==1 set /a v+=1
	)
	if %debug%==1 set branchs
	
	
	set bstr_a=
	set bstr_b=
	REM NEQ - 不等于 
	if "!branchs_a!" NEQ "" (
		set bstr_a=[!branchs_a!](https://github.com/KumaDocCenter/!name!/tree/!branchs_a!^)
	)
	if "!branchs_b!" NEQ "" (
		set bstr_b=[!branchs_b!](https://github.com/KumaDocCenter/!name!/tree/!branchs_b!^)
	)
	
	REM 输出md文件
	echo ^* [!name!](!git!^) >>RepoList.md
	echo   ^* 初始化时间： !init_date!  >>RepoList.md
	echo   ^* 初始分支： !bstr_a!   !bstr_b!  >>RepoList.md
	
	REM 输出子仓库配置文件
	REM call  :outRepoList_Config  !name!   "!init_date!"  !RepoOut!  !branch!  !branchs!

	REM 移动文件
	move /Y %%i  %cd%\%~2
		
	if %debug%==1 echo -------FileCount：!f! ----------------
	if %debug%==1 set /a f+=1
)
GOTO:EOF
:: ==========[Function]================================================================== ::




:: ==========[Function]================================================================== ::
::outRepoList_Config_test
:::::::: 调用示例 ::::::::
:: call  :outRepoList_Config  %dirname%  "%datetime%"  data\Repo\conf\staged  %branch%  %branchs%

GOTO:EOF
:: ================================================== ::
:: 函数名称：outRepoList_Config					 	  ::
:: 函数功能：输出子仓库配置文件						  ::
:: 函数参数：arg1: 子仓库名			 	  			  ::
::                 子仓库相对路径			 		  ::
::           arg2: 日期时间						  	  ::
::           arg3: 输出目录					  	 	  ::
::                 相对路径(相对于运行目录 ./ ) 	  ::
::                 如 data\Repo\conf\staged 		  ::
::                 绝对路径						 	  ::
::                 如 K:\data\Repo\conf\staged 		  ::
::           arg4: 分支					  	 	 	  ::
::           arg5: 所有分支					  	 	  ::
::           arg6: 脚本1					  	 	  ::
::           arg7: 脚本2					  	 	  ::
:: 返回值： 									 	  ::
:: 													  ::
:: ================================================== ::
:outRepoList_Config

::::::::::参数接收::::::::::::::::
set "_dirname=%~1"
set "_datetime=%~2"
set "_path=%~3"
set "_type=Repo"
::::::::::参数接收::::::::::::::::

:: 目录不存在，则创建
if not exist  %_path%  mkdir %_path%

::::::::::变量配置::::::::::::::::
set "dn=%_path%\%_dirname%.%_type%"
set git=https://github.com/KumaDocCenter/%_dirname%.git
set name=%_dirname%
set branch=%~4
set branchs=%~5
set "init_date=%_datetime%"
set sh=%~6
set sh2=%~7

REM %~dp0 : K:\...\Script\sh\

::::::::::变量配置::::::::::::::::

if %debug%==1 echo ------------------------ 输出子仓库配置文件  ------------------------
echo ###################################################### >%dn%
echo #  子仓库批处理配置文件 >>%dn%
echo #  后缀   		作用 >>%dn%
echo # .Repo        初始化并检出子仓库 >>%dn%	
echo #------------------------------------------------ >>%dn%
echo #  git        :  git 地址 >>%dn%
echo #  name       :  子仓库名称 >>%dn%
echo #  branch     :  子仓库分支 >>%dn%
echo #  branchs    :  子仓库所有分支  >>%dn%
echo #  init_date  :  子仓库初始化时间 >>%dn%
echo #  sh  	   	  :  待执行的额外脚本 路径 >>%dn%
echo #  sh2  	  :  待执行的额外脚本 路径 >>%dn%
echo ###################################################### >>%dn%
echo git=%git%>>%dn%
echo name=%name%>>%dn%
echo branch=%branch%>>%dn%
echo branchs=%branchs%>>%dn%
echo init_date=%init_date%>>%dn%
echo sh=%sh%>>%dn%
echo sh2=%sh2%>>%dn%

echo. 
echo 用于子仓库的配置文件已生成
echo [ %dn% ]
echo.
if %debug%==1 echo ------------------------ 输出子仓库配置文件  ------------------------
GOTO:EOF
:: ==========[Function]================================================================== ::


