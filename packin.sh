#!/usr/bin/env bash

#####################################################
# Package(s) installer v.1.0
# --
# Installing dozens of packages has never been so easy.
# Symply by marking the package name you want, then this
# program will take care the rest of it.
# ---------------
# Author: arfanamd
# Github: https://github.com/arfanamd
# Licence: GPL v3
#####################################################

# due to portability reasons with termux user,
# since termux doesn't need root privileges when
# installing a package
#
which sudo > /dev/null 2>&1
[[ $? != 0 ]] && MODE=1 || MODE=2

# the package manager command variable; configure these variables to match with your distro package manager.
__package_manager=${__package_manager:=apt}
__package_install=${__package_install:=${__package_manager} install}
__package_update=${__package_update:=${__package_manager} update}
__package_list=${__package_list:=${__package_manager} list}

which fzf > /dev/null 2>&1
[[ $? != 0 ]] && {
	if [[ $MODE == 1 ]]; then
		echo -e "\n\e[1;31merror:\e[0m fzf is not installed yet.\n"
		echo -n "Do you want to install it [Y / N]? "
		read -n1 answer

		if [[ $answer == y* ]] || [[ $answer == Y* ]]; then
			${__package_update} && ${__package_install} fzf
		else
			echo -e "\n\e[1;33mwarning:\e[0m this program need fzf utility to run.\n"
			exit 0;
		fi
	elif [[ $MODE == 2 ]]; then
		cat << EOF

 This program need an fzf utility to run, you can install it
 by cloning this repository https://github.com/junegunn/fzf
 or if your distribution has provided it, you can install
 it by yourself.

EOF
		exit 0;
	fi
}

# read the fzf manual for more information of these options entered!
__fzf_program='/usr/bin/env fzf -m --layout=reverse-list --prompt=search: '

# updating repo..
${__package_update}

__selected_packages=$($__package_list 2> /dev/null | sed -n '1!p' | $__fzf_program | tr ' ' '.')
__selected_packages=($(echo -e "${__selected_packages}"));

for ((i = 0; i < ${#__selected_packages[@]}; i++)); do
	case $MODE in
		1) ${__package_install} ${__selected_packages[i]%/*};;
		2) sudo ${__package_install} ${__selected_packages[i]%/*};;
	esac
done

echo -e "\n-- \e[1;92m${#__selected_packages[@]}\e[0m new package(s) installed --"

unset __package_manager __package_install __package_update __package_list
unset __list_available_package __fzf_program __selected_packages

#__end_of_file__
