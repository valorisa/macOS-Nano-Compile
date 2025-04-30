#!/bin/bash

# Script d'installation de GNU nano 8.4 avec support UTF-8 sur macOS Sequoia
# Hypothse : Homebrew est dj install

set -e

# 1. Installer ncurses (pour ncursesw)
echo "Installation de ncurses via Homebrew..."
brew update && brew upgrade && brew install ncurses

# 2. Telecharger les sources de nano 8.4
cd /tmp
echo "Telechargement de nano 8.4..."
curl -LO https://www.nano-editor.org/dist/v8/nano-8.4.tar.gz

echo "Extraction de l'archive..."
tar -xzf nano-8.4.tar.gz
cd nano-8.4

# 3. Detecter le chemin Homebrew selon l'architecture
if [[ -d "/opt/homebrew/opt/ncurses" ]]; then
  NCURSES_PREFIX="/opt/homebrew/opt/ncurses"
else
  NCURSES_PREFIX="/usr/local/opt/ncurses"
fi

# 4. Configurer la compilation avec ncursesw et UTF-8
echo "Configuration de la compilation avec support UTF-8..."
LDFLAGS="-L${NCURSES_PREFIX}/lib" CPPFLAGS="-I${NCURSES_PREFIX}/include" ./configure --prefix=/usr/local

# 5. Compilation et installation
echo "Compilation..."
make

echo "Installation (sudo requis)..."
sudo make install

# 6. Nettoyage
cd ..
rm -rf nano-8.4 nano-8.4.tar.gz

# 7. Verification
echo
echo "Verification de l'installation:"
/usr/local/bin/nano --version

echo
echo " Installation terminee. Lancez 'nano --version' pour verifier."
