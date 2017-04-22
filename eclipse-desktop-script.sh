#!/bin/bash
path=/usr/share/applications/eclipse.desktop

if [ "$(id -u)" != "0" ]; then
	echo "Super user privileges required, use sudo"
	exit
fi

echo "Insert entry name:"
read name

echo "Looking for eclipse executable..."

#gather all the eclipse executables present in ~ and /opt/ (usual installation directories)
read -r -a eclipse << get_executables
$(find $HOME /opt -not -path '*\/\.local*' -type f -name eclipse -perm /u=x 2>/dev/null)
get_executables


#let user select the executable to create desktop shortcut
if [ ${#eclipse[@]} -gt 1 ]; then
	echo "Select the executable you want to create the desktop entry:"
	select opt in "${eclipse[@]}"; do
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
icon=$(find "$(dirname $executable)" -type f -name icon.xpm 2>/dev/null)


#create the desktop entry
printf "[Desktop Entry]\nType=Application\nName=%s\nComment=Eclipse Integrated Development Environment\n" "$name" > $path
if [ "$icon" == "" ];then
	echo "Icon not found"
else
	echo "Icon=$icon" >> $path
fi
printf "Exec=%s\nTerminal=false\nCategories=Development;IDE\nStartupWMClass=Eclipse\n" $executable >> $path

echo "Desktop entry created with success! have fun"
