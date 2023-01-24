@echo off

title FNF Setup
echo Press any key to continue!
pause >nul
title FNF Setup - Installing libs
echo Installing libs haxelib...
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib install hxCodec
haxelib install flixel-addons
haxelib install flixel-ui
haxelib install hscript
haxelib run lime setup
haxelib install flixel-tools
exit