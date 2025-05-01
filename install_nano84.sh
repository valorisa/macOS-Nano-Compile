#!/bin/bash

# Script d'installation de GNU nano 8.4 avec support UTF-8 sur macOS Sequoia
# Hypothese : Homebrew est deja installe

set -e

echo "=== Installation de ncurses via Homebrew ==="
brew update && brew upgrade && brew install ncurses

cd /tmp
echo "=== Téléchargement de nano 8.4 ==="
curl -fLO https://www.nano-editor.org/dist/v8/nano-8.4.tar.gz

echo "=== Extraction de l'archive ==="
tar -xzf nano-8.4.tar.gz
cd nano-8.4

# Détection du préfixe Homebrew selon l’architecture
if [[ -d "/opt/homebrew/opt/ncurses" ]]; then
  NCURSES_PREFIX="/opt/homebrew/opt/ncurses"
else
  NCURSES_PREFIX="/usr/local/opt/ncurses"
fi

echo "=== Configuration de la compilation avec support UTF-8 ==="
LDFLAGS="-L${NCURSES_PREFIX}/lib" CPPFLAGS="-I${NCURSES_PREFIX}/include" ./configure --prefix=/usr/local

echo "=== Compilation ==="
make

echo "=== Installation (sudo requis) ==="
if ! command -v sudo >/dev/null 2>&1; then
  echo "Erreur : sudo n'est pas disponible. Installez sudo ou lancez ce script en tant que root."
  exit 1
fi
sudo make install

echo "=== Nettoyage ==="
cd ..
rm -rf nano-8.4 nano-8.4.tar.gz

echo
echo "=== Vérification de l'installation ==="
/usr/local/bin/nano --version

echo
echo "Installation terminée. Lancez 'nano --version' pour vérifier."
