# packin
terminal based package installer.

add: with the description of the package.

##### screenshot
![screenshot_1](./screenshot/scr.gif)

## Install
This program required [fuzzy-finder](https://github.com/junegunn/fzf) utility to run, so you have to install [fzf](https://github.com/junegunn/fzf) first.

##### Clone this repo
```
git clone https://github.com/arfanamd/packin.git && cd packin && chmod 755 packin.sh
```

##### or directly copy the script using curl
```
curl https://raw.githubusercontent.com/arfanamd/packin/master/packin.sh > ~/packin.sh && chmod 755 ~/packin.sh
```

## Usage
##### run the script normal mode: 
    ./packin.sh
##### run the script upgradable mode:
    ./packin.sh --upgradable

* `TAB-Key` -> is used to mark the package that you want to install.
* `search` -> type directly to filter search result.
* `Enter-Key` -> start installing the marked packages.
