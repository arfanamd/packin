# package(s) installer v.2.0
# --------------------------
# Installing dozens of packages has never been so easy.
# Simply by tagging the package name you want and then
# this program does the rest for you.
# -----------------------------------
# Author  : arfanamd
# License : GPLv3+
# Project : <https://github.com/arfanamd/packin
# *****************************************************
#!/usr/bin/env bash

which fzf &> /dev/null
if [[ $? != 0 ]]; then
	printf "%s\n%s n%s\n" \
	"error: fzf not installed" "install it first!" \
	"<http://github.com/junegunn/fzf>"
	exit 1
fi

#- due to compatibility to termux user, since termux doesn't
# need root priviledge to install a package.
which sudo &> /dev/null
[[ $? == 0 ]] && _mode='sudo' || _mode=''

_var=${1}

#- match the values of these variables (5) to your distribution's package manager.
_pkgManager=${_pkgManager:=apt}
_pkgDescrib=${_pkgDescrib:=${_pkgManager} show}
_pkgListall=${_pkgListall:=${_pkgManager} list}
_pkgUpgrade=${_pkgUpgrade:=${_pkgListall} --upgradable}
_pkgInstall=${_pkgInstall:=${_pkgManager} install}

_nCounter=0
_uCounter=0

if [[ ${_var} =~ '--upgr' ]]; then
	_selectedPkg=$(${_pkgUpgrade} 2> /dev/null|sed -n '1!p'| \
                fzf -m --layout=reverse-list --preview-window=bottom:50%:wrap \
                --preview="echo {}|sed -e 's,/[a-zA-Z]*.*,,g'|xargs ${_pkgDescrib} 2> /dev/null"|tr ' ' '.')
else
        _selectedPkg=$(${_pkgListall} 2> /dev/null|sed -n '1!p'| \
                fzf -m --layout=reverse-list --preview-window=bottom:50%:wrap \
                --preview="echo {}|sed -e 's,/[a-zA-Z]*.*,,g'|xargs ${_pkgDescrib} 2> /dev/null"|tr ' ' '.')
fi

_selectedPkg=(${_selectedPkg})

unset _var _pkgManager _pkgDescrib _pkgListall _pkgUpgrade

printf "\e[?1049h\e[2J\e[1H"
#- instalation process
for ((pkgs = 0; pkgs < ${#_selectedPkg[@]}; pkgs++)); do
        ${_mode} ${_pkgInstall} ${_selectedPkg[pkgs]%/*} -y
        if [[ $? == 0 ]]; then
		if [[ ${_selectedPkg[pkgs]} =~ 'installed' || ${_selectedPkg[pkgs]} =~ 'upgradable' ]]; then
                        ((_uCounter++))
                else
                        ((_nCounter++))
                fi
        fi
done

printf "\e[2J\e[1H\e[?1049l-- %d %s %d %s --\n" "${_nCounter}" \
        "new package(s) installed &" "${_uCounter}" "package(s) upgraded"

unset _pkgInstall _selectedPkg _mode _uCounter _nCounter
