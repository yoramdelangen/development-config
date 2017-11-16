    # My configs
This is a set of my current used configs.

I created a directory which links to all other config directories. Because OSX doesnt support itI used a tool called `hardlink-osx` (`hln`) for it.

## Sublime Text - Primary editor
Wihtin `tools/SublimeText3/` is a hardlink to `/Users/Yoram/Library/Application\ Support/Sublime\ Text\ 3/Packages/User`.

## Atom
Wihtin `tools/Atom/` is a hardlink to `~/.atom/`.

To save all packages I used this command:
```
apm list --installed --bare > ~/.atom/package.list
```
and to restore the packages:
```
apm install --packages-file ~/.atom/package.list
```
> In the future looking for this: https://atom.io/packages/sync-settings

## PHPStorm
Wihtin `tools/PHPStorm/Config/` is a hardlink to `~/Library/Preferences/PhpStorm2017.1`.
Wihtin `tools/PHPStorm/Packages/` is a hardlink to `~/Library/Application\ Support/PhpStorm2017.1`.

## Composer
Composer is linked with the global composer `~/.composer/`.

### PHP Code style
This can be done via command-line but mostly via Sublime Text.
To quickly on the command-line apply CS Fix on all PHP files in a certain directory:
```
php-cs-fixer fix ${file_name} --config=/Users/Yoram/.scripts/php_cs.dist
# or
php-cs-fixer fix ${directoy} --config=/Users/Yoram/.scripts/php_cs.dist
```

## NPM global list
Getting a global list of all installed NPM packages:
```
npm list -g --depth=0 > npm.list
```

# Links
## HLN
```
hln /Users/Yoram/Library/Application Support/Sublime\ Text\ 3/Packages/User tools/SublimeText3/
hln ~/.atom/ tools/Atom/
hln ~/.scripts/ scripts/
hln ~/Library/Preferences/PhpStorm2017.1 tools/PHPStorm/Config
hln ~/Library/Application\ Support/PhpStorm2017.1 tools/PHPStorm/Packages
```

## Softlinks
```
ln ~/.bash_aliases bash/
ln ~/.bash_exports bash/
ln ~/.gitconfig bash/
ln ~/.zshrc bash/
```