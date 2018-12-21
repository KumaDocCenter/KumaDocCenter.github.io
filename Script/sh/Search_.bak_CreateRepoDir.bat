:: ============================================================================= ::
:: 在另一位置创建子仓库的空目录
::
:: 根据指定目录下的 目录命名的后缀 .bak 进行处理
:: .bak 后缀的目录，通常为子仓库初始化前的备份
:: 
:: 注：脚本和DevDocCenter目录同级存在 
::
:: 存放目录： 
:: 运行目录： 
:: 
:: ============================================================================= ::

:: 关闭回显
@echo off
:: 开启变量延迟
setlocal enabledelayedexpansion

:: 调试开关
set debug=0

:: 存储感叹号 ! 
set "T=^!"

set spath=DevDocCenter
set dpath=DevDocCenter_md

cd %~dp0

:: 设置根目录路径
set root=%cd%
:: 设置当前脚本路径
set thispath=%~dp0

:: 判断有没有指定目录
if not exist %spath% (
	echo 脚本所在目录下没有 [ %spath% ] 目录
	echo 脚本即将退出...
	pause
	exit
)

:: ------------------------------------------------------------------
:: 根据指定目录下的 目录命名的后缀 .bak 进行处理
:: .bak 后缀的目录，通常为子仓库初始化前的备份
:: 
:: ------------------------------------------------------------------
echo START----------------------------------------------------------------
for /f "usebackq delims=" %%i in (`dir /ad /b/s %root%%spath%\*.bak`) do (
	if %debug%==1  echo fullpath: %%i
	set str=%%i
	REM 路径后缀.bak替换为空
	REM K:\DevDocCenter\NoSQL\Redis
	set str=!str:.bak=!
	REM 路径前缀替换为空
	REM NoSQL\Redis
	set str=!str:%root%%spath%\=!
	REM 相对路径
	set RelativePath=!str!
	
	if %debug%==1  echo RelativePath:!RelativePath! 
	if exist "%root%%dpath%\!RelativePath!" (
		echo 目录已存在: [ %root%%dpath%\!RelativePath! ] 
		echo.
	) else (
		mkdir "%root%%dpath%\!RelativePath!"  && (			
			echo 目录创建成功: [ %root%%dpath%\!RelativePath! ]  
			echo.
		) || (			
			echo 目录创建失败: [ %root%%dpath%\!RelativePath! ] 
			echo.
		)	
	)
	
)
echo END------------------------------------------------------------------
pause
exit
