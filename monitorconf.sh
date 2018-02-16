#!/bin/bash

#check if CRT1 is connectedA

function docking {
	exec xrandr --output LVDS-1 --off --output VGA-1 --auto --primary &
}

function undocking {
	exec xrandr --output LVDS-1 --auto --primary --output VGA-1 --off &
}

function extended {
	exec xrandr --output VGA-1 --primary --output LVDS-1 --auto --right-of VGA-1
}

case $1 in 
	"start")	
		if (xrandr | grep "VGA-1 connected" > /dev/null) ; then
			
			# If laptop lid open: Turn on both screens
			# If laptop lid closed: Turn only external monitor screen
			grep -q closed /proc/acpi/button/lid/LID/state
			if [ $? = 0 ] ; then 
				docking
				notify-send 'Laptop lid state: Closed' 'Only external monitor turned ON' -i info 
			else
				# lid is open
				extended
				notify-send 'Laptop lid state: Open' 'Both screens are now turned ON. \nLEFT :\tExternal Monitor \nRIGHT :\tLaptop Screen' -i info
			fi 
			if [ $? -ne 0 ]; then
				 # Something went wrong. Autoconfigure the internal monitor and disable the external one
				undocking
			fi
		else
			xrandr --output LVDS-1 --primary &
		fi
		;;
	"docking")
		docking
		;;
	"undocking")
		undocking
		;;
	"extended")
		extended
		;;
	*)
esac		


exit
