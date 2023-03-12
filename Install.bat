@echo off
::
::
::
::
::download curl.exe from https://curl.se/windows/
::
::
::
::
::the -k param is used to allow certificate errors
::the -L param is used to follow redirections

SET VERSION=0.129.3.45
SET BMAX_FILE=BlitzMax_win32_%VERSION%.7z
SET BMAX_URL="https://github.com/bmx-ng/bmx-ng/releases/download/v%VERSION%.win32/%BMAX_FILE%"

if not exist "C:\Program Files\7-Zip\7z.exe" (
	echo "Please install 7zip first.."
	pause
	exit )
if not exist "BlitzMaxNG.downloads" mkdir "BlitzMaxNG.downloads"

 
IF EXIST "BlitzMaxNG.downloads/brl.mod.zip" (
        echo "downloads exist ... skipping"
) ELSE (
        curl -k -L %BMAX_URL% -o "BlitzmaxNG.downloads/%BMAX_FILE%"
 
        curl -k -L "https://github.com/bmx-ng/bcc/archive/refs/heads/master.zip" -o "BlitzMaxNG.downloads/bcc.zip"
        curl -k -L "https://github.com/bmx-ng/bmk/archive/refs/heads/master.zip" -o "BlitzMaxNG.downloads/bmk.zip"
 
        curl -k -L "https://github.com/bmx-ng/brl.mod/archive/refs/heads/master.zip" -o "BlitzMaxNG.downloads/brl.mod.zip"
        curl -k -L "https://github.com/bmx-ng/pub.mod/archive/refs/heads/master.zip" -o ""BlitzMaxNG.downloads/pub.mod.zip"
        curl -k -L "https://github.com/bmx-ng/audio.mod/archive/refs/heads/master.zip" -o ""BlitzMaxNG.downloads/audio.mod.zip"
        curl -k -L "https://github.com/bmx-ng/text.mod/archive/refs/heads/master.zip" -o "BlitzMaxNG.downloads/text.mod.zip"
        curl -k -L "https://github.com/bmx-ng/random.mod/archive/refs/heads/master.zip" -o "BlitzMaxNG.downloads/random.mod.zip"
        curl -k -L "https://github.com/bmx-ng/sdl.mod/archive/refs/heads/master.zip" -o "BlitzMaxNG.downloads/sdl.mod.zip"
        curl -k -L "https://github.com/bmx-ng/net.mod/archive/refs/heads/master.zip" -o "BlitzMaxNG.downloads/net.mod.zip"
        curl -k -L "https://github.com/bmx-ng/image.mod/archive/refs/heads/master.zip" -o "BlitzMaxNG.downloads/image.mod.zip"
        curl -k -L "https://github.com/bmx-ng/maxgui.mod/archive/refs/heads/master.zip" -o "BlitzMaxNG.downloads/maxgui.mod.zip"
		curl -k -L "https://github.com/bmx-ng/database.mod/archive/refs/heads/master.zip" -o "BlitzMaxNG.downloads/database.mod.zip"
		
		curl -k -L "https://github.com/maxmods/wx.mod/archive/refs/heads/master.zip" -o "BlitzMaxNG.downloads/wx.mod.zip"
)

 
::prepare NG
echo "Preparing latest stable NG"
cd "BlitzMaxNG.downloads"
IF EXIST "BlitzMax" (
        echo "blitzmax unzipped... skipping"
) ELSE (
"C:\Program Files\7-Zip\7z" x "%BMAX_FILE%" -r -y
)
 
 
echo "Preparing module updates"
IF EXIST "mod/brl.mod" (
        echo "mods prepared ... skipping"
) ELSE (
"C:\Program Files\7-Zip\7z" x "brl.mod.zip" -o"mod" -r -y
"C:\Program Files\7-Zip\7z" x "pub.mod.zip" -o"mod" -r -y
"C:\Program Files\7-Zip\7z" x "audio.mod.zip" -o"mod" -r -y
"C:\Program Files\7-Zip\7z" x "text.mod.zip" -o"mod" -r -y
"C:\Program Files\7-Zip\7z" x "random.mod.zip" -o"mod" -r -y
"C:\Program Files\7-Zip\7z" x "sdl.mod.zip" -o"mod" -r -y
"C:\Program Files\7-Zip\7z" x "net.mod.zip" -o"mod" -r -y
"C:\Program Files\7-Zip\7z" x "image.mod.zip" -o"mod" -r -y
"C:\Program Files\7-Zip\7z" x "maxgui.mod.zip" -o"mod" -r -y
"C:\Program Files\7-Zip\7z" x "database.mod.zip" -o"mod" -r -y

"C:\Program Files\7-Zip\7z" x "wx.mod.zip" -o"mod" -r -y
 
::rename modules
cd mod
ren "brl.mod-master" "brl.mod"
ren "pub.mod-master" "pub.mod"
ren "audio.mod-master" "audio.mod"
ren "text.mod-master" "text.mod"
ren "random.mod-master" "random.mod"
ren "sdl.mod-master" "sdl.mod"
ren "net.mod-master" "net.mod"
ren "image.mod-master" "image.mod"
ren "maxgui.mod-master" "maxgui.mod"
ren "database.mod-master" "database.mod"

ren "wx.mod-master" "wx.mod"
cd ..
)
 
 
::unzip tools
"C:\Program Files\7-Zip\7z" x "bcc.zip" -o"tools" -r -y
"C:\Program Files\7-Zip\7z" x "bmk.zip" -o"tools" -r -y
 
 
::compile bcc
echo "Compiling bcc"
cd "BlitzMax/bin"
bmk.exe makeapp -r -t console "../../tools/bcc-master/bcc.bmx"
cd ../..
echo "Updating bcc"
cd "tools/bcc-master"
copy /Y "bcc.exe" "../../Blitzmax/bin/bcc.exe"
cd ../..
 
::update modules - so we can update bmk
cd Blitzmax
ren "mod" "mod.old"
cd ..
move /Y "mod" "Blitzmax/mod"
 
 
::compile bmk
echo "Compiling bmk"
cd "BlitzMax/bin"
bmk.exe makeapp -r -t console "../../tools/bmk-master/bmk.bmx"
cd ../..
echo "Updating bmk"
cd "tools/bmk-master"
copy /Y "bmk.exe" "../../Blitzmax/bin/bmk.exe"
copy /Y "core.bmk" "../../Blitzmax/bin/core.bmk"
copy /Y "custom.bmk" "../../Blitzmax/bin/core.bmk"
copy /Y "make.bmk" "../../Blitzmax/bin/make.bmk"
cd ../..

::delete temp files
rd /s /q "tools"
del %BMAX_FILE%
del "bcc.zip"
del "bmk.zip"
del "brl.mod.zip"
del "pub.mod.zip"
del "audio.mod.zip"
del "text.mod.zip"
del "random.mod.zip"
del "sdl.mod.zip"
del "net.mod.zip"
del "image.mod.zip"
del "maxgui.mod.zip"
del "database.mod.zip"
del "wx.mod.zip"

cd ..
echo "Setup is complete. You can close now.."
pause