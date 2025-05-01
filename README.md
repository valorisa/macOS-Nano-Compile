# Compiler et Installer Nano 8.4 sur macOS Sequoia (et versions récentes)

Ce guide explique comment compiler la version 8.4 de l'éditeur de texte GNU Nano depuis les sources sur macOS, et présente des alternatives plus simples utilisant des gestionnaires de paquets.

Pourquoi la compilation manuelle de nano 8.4 sur macOS Sequoia ?

Par défaut, macOS Sequoia intègre l’éditeur Pico (version 5.09) et la commande nano pointe en réalité vers ce binaire pico fourni par Apple. Pour disposer de GNU nano 8.4, il faut télécharger ses sources sur le site officiel et disposer des outils de compilation (Xcode Command Line Tools) ainsi que de la bibliothèque `ncurses`. Ensuite, il suffit de décompresser l’archive, de configurer le projet avec un préfixe adapté, de compiler avec `make`, puis d’installer avec `make install`.

Pourquoi nano renvoie à pico sur macOS Sequoia ?

Sur macOS Sequoia, la commande nano référence un binaire pico ancien (version 5.09) fourni par Apple, et non GNU nano.
Apple a choisi d’inclure pico, issu du client mail Pine (développé à l’Université de Washington), comme éditeur en ligne de commande par défaut pour des raisons historiques et de licence.
En pratique, l’exécutable nano est un lien symbolique vers pico, ce qui explique pourquoi `nano --version` affiche « Pico 5.09 ».
GNU nano vise historiquement à remplacer pico, mais cette version n’est pas celle livrée par Apple sur macOS Sequoia.

**Version cible :** Nano 8.4 (`https://www.nano-editor.org/dist/latest/nano-8.4.tar.gz`)

## Méthode 1 : Compiler depuis les Sources

Cette méthode vous donne la version la plus récente immédiatement et un contrôle total sur les options de compilation, mais nécessite des étapes manuelles.

### Prérequis

**Xcode Command Line Tools :** Fournit le compilateur (Clang) et les outils de build (`make`, etc.).
    a) Ouvrez Terminal (`Applications/Utilitaires/Terminal`).
    b)   Exécutez :
        ```
        xcode-select --install
        ```
    c)   Suivez les instructions à l'écran. Ressemble à ce qui suit quand tout est bon  :

```text
    % xcode-select --install
xcode-select: note: Command line tools are already installed. Use "Software Update" in System Settings or the softwareupdate command line interface to install updates
```

1. **Dépendances (via Homebrew) :** Nano a besoin de `ncurses` (interface) et `gettext` (internationalisation). Installer des versions via Homebrew est souvent préférable à celles du système pour une meilleure compatibilité et fonctionnalités (ex: UTF-8).
    * **Installer Homebrew** (si vous ne l'avez pas) :

        ```bash
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        ```

        Suivez les instructions (peut nécessiter d'ajouter Homebrew à votre `PATH`).
    * **Installer les dépendances :**

        ```bash
        brew install ncurses gettext pkg-config
        ```

        (`pkg-config` aide à localiser les bibliothèques installées).

### Étapes de Compilation

1. **Télécharger les Sources :**

    ```bash
    # Allez dans un répertoire de travail, par exemple Downloads
    cd ~/Downloads
    # Téléchargez l'archive
    curl -LO https://www.nano-editor.org/dist/latest/nano-8.4.tar.gz
    ```

    *(Alternative : `wget https://www.nano-editor.org/dist/latest/nano-8.4.tar.gz`)*

2. **Extraire l'Archive :**

    ```bash
    tar -xzf nano-8.4.tar.gz
    ```

3. **Naviguer vers le Répertoire des Sources :**

    ```bash
    cd nano-8.4
    ```

4. **Configurer le Build :**
    * Exporte les chemins pour que `configure` trouve les bibliothèques Homebrew (`ncurses`, `gettext`) :

        ```bash
        export PKG_CONFIG_PATH="$(brew --prefix ncurses)/lib/pkgconfig:$(brew --prefix gettext)/lib/pkgconfig"
        export LDFLAGS="-L$(brew --prefix ncurses)/lib -L$(brew --prefix gettext)/lib"
        export CPPFLAGS="-I$(brew --prefix ncurses)/include -I$(brew --prefix gettext)/include"
        ```

    * Lancez le script de configuration :

        ```bash
        ./configure --prefix=/usr/local --enable-utf8 --enable-nls
        ```

        * `--prefix=/usr/local`: Définit le répertoire d'installation (standard pour Homebrew et logiciels tiers).
        * `--enable-utf8`: Active le support UTF-8.
        * `--enable-nls`: Active le support multilingue (via `gettext`).
        * *(Astuce: `./configure --help` pour voir toutes les options)*

5. **Compiler le Code :**

    ```bash
    make
    ```

6. **(Optionnel) Lancer les Tests :**

    ```bash
    make check
    ```

7. **Installer Nano :**

    ```bash
    sudo make install
    ```

    *(Le `sudo` est nécessaire pour écrire dans `/usr/local/bin`, etc.)*

8. **Vérifier l'Installation :**
    * Ouvrez un nouveau terminal ou rafraîchissez les chemins : `hash -r` (bash) ou `rehash` (zsh).
    * Vérifiez quel `nano` est utilisé :

        ```bash
        which nano
        ```

        Devrait afficher `/usr/local/bin/nano`. Si ce n'est pas le cas, assurez-vous que `/usr/local/bin` est avant `/usr/bin` dans votre `PATH` (via `~/.zshrc`, `~/.bash_profile`, etc.).
    * Vérifiez la version :

        ```bash
        nano --version
        ```

        Devrait afficher `GNU nano, version 8.4`.

## Méthode 2 : Installation Alternatives (Recommandé)

Utiliser un gestionnaire de paquets est généralement plus simple et facilite les mises à jour.

### 1. Homebrew (Recommandé)

Homebrew est le gestionnaire de paquets le plus populaire sur macOS.

1. **Installer/Mettre à jour Homebrew :**
    * Installation : Voir la commande dans les prérequis de la Méthode 1.
    * Mise à jour :

        ```bash
        brew update
        ```

2. **Installer Nano :**

    ```bash
    brew install nano
    ```

    Homebrew installe généralement la dernière version stable disponible, qui pourrait déjà être la 8.4 ou le sera très bientôt. Il gère les dépendances automatiquement.

3. **Mettre à jour Nano (plus tard) :**

    ```bash
    brew upgrade nano
    ```

4. **Vérification :**
    * `which nano` devrait pointer vers `/usr/local/bin/nano` (Intel) ou `/opt/homebrew/bin/nano` (Apple Silicon).
    * `nano --version` affichera la version installée.

### 2. MacPorts

MacPorts est une autre alternative robuste à Homebrew.

1. **Installer/Mettre à jour MacPorts :**
    * Suivez les instructions d'installation sur le site de MacPorts.
    * Mise à jour :

        ```bash
        sudo port selfupdate
        ```

2. **Installer Nano :**

    ```bash
        sudo port install nano
    ```

    MacPorts installe typiquement les logiciels dans `/opt/local`. Assurez-vous que `/opt/local/bin` est dans votre `PATH`.

3. **Mettre à jour Nano (plus tard) :**

    ```bash
    sudo port upgrade nano
    ```

## Conclusion et Recommendation

* **Compiler depuis les sources :**
  * **Avantages :** Accès immédiat à la version 8.4 exacte, contrôle total des options.
  * **Inconvénients :** Plus complexe, gestion manuelle des dépendances et des mises à jour.
  * **Quand l'utiliser ?** Si vous avez besoin de la 8.4 *maintenant* et qu'elle n'est pas encore sur les gestionnaires de paquets, ou si vous nécessitez des options de compilation spécifiques.

* **Gestionnaires de Paquets (Homebrew/MacPorts) :**
  * **Avantages :** **Simplicité**, gestion automatique des dépendances, mises à jour faciles (`brew upgrade` / `port upgrade`).
  * **Inconvénients :** Peut y avoir un léger délai avant que la toute dernière version (8.4) soit disponible.
  * **Quand l'utiliser ?** **Dans la plupart des cas.** C'est la méthode recommandée pour sa facilité d'utilisation et de maintenance.

**Recommandation :** Essayez d'abord `brew install nano`. Si la version 8.4 n'est pas encore disponible et que vous en avez absolument besoin, suivez les étapes de compilation manuelle.
