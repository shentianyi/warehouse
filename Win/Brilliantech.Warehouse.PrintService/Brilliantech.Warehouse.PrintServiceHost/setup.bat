@echo off

:: 安装工具 
:: 第一个是32位版的，第二个是64位版的， 注意： 在64位系统中，2个都可以用，根据需求选择

if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set InstallUtil=%windir%\Microsoft.NET\Framework64\v2.0.50727\InstallUtil.exe  else set InstallUtil=%windir%\Microsoft.NET\Framework\v2.0.50727\InstallUtil.exe 

::服务程序文件
set Service=DDNSService.exe

::服务端口
set port=9000

::服务显示名字
set Name="WMS Client Host Service"


if "%1"=="/u" goto Uninstall



  echo 正在安装服务 %Name%

  ::%InstallUtil% %Service%


  echo 正在配置本地端口


  netsh http add urlacl url=http://+:%port%/  sddl="D:(A;;GX;;;SY)"

  netsh http add iplisten ipaddress=0.0.0.0:%port%

  echo 正在设置防火墙

  netsh advfirewall firewall add rule name=%Name% dir=in action=allow protocol=TCP localport=%port%


  ::启动服务，可以注释掉
  echo 启动服务

  ::net start %Name%

  echo 安装完毕！ 你可以运行 “Setup.bat” /u 进行卸载。

  goto end

:Uninstall

  echo 开始卸载服务
  
  echo 正在停止服务

  net stop %Name%
  
  echo 正在卸载服务 %Name%

  ::%InstallUtil% %Service% /u


  echo 正在清理本地端口配置

  netsh http delete urlacl url=http://+:%port%/ 

  netsh http delete iplisten ipaddress=0.0.0.0

  echo 正在清理防火墙设置

  netsh advfirewall firewall delete rule name=%Name% 

 
  echo 卸载完毕！ 

  goto end
  

:end
pause


