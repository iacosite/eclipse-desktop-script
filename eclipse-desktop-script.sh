#!/bin/bash
path=/usr/share/applications/eclipse.desktop

if [ $(id -u)  -gt 0 ]; then
	echo "Super user privileges required, use sudo"
	exit
fi

echo "Insert entry name:"
read name

echo "Looking for eclipse executable..."
#gather all the eclipse executables present in ~ and /opt/ (usual installation directories)
read -a eclipse <<<$(find $HOME /opt -not -path '*\/\.local*' -type f -name eclipse -perm /u=x 2>/dev/null)

#let user select the executable to create desktop shortcut
if [ ${#eclipse[@]} -gt 1 ]; then
	echo "Select the executable you want to create the desktop entry:"
	select opt in ${eclipse[@]}; do
		executable=$opt
		break
	done
else
	executable=$eclipse
fi
if [ ! -x $executable ]; then
	echo "Input file is not correct"
	exit
fi

#locate the icon file
icon=$(find $(dirname $executable) -type f -name icon.xpm 2>/dev/null)


#create the desktop entry
echo [Desktop Entry] > $path
echo Type=Application >> $path
echo Name=$name >> $path
echo Comment=Eclipse Integrated Development Environment >> $path
if [ "$icon" == "" ];then
	echo "Icon not found"
else
	echo Icon=$icon >> $path
fi
echo Exec=$executable >> $path
echo Terminal=false >> $path
echo Categories=Development\;IDE >> $path
echo StartupWMClass=Eclipse >> $path

echo "Desktop entry created with success! have fun"

