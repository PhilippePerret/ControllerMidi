# ControllerMidi

C'est un contrôleur par MIDI, pour pouvoir se servir du clavier maitre pour gérer tout un tas de trucs. Exemple : 

* pouvoir obtenir très rapidement toutes mes adresses mails,
* pouvoir obtenir les adresses des livres
* obtenir les adresses des sites
* ouvrir le fichier des commentaires Icare, ou le dossier des commentaires, ou rejoindre le site
* contrôler une application par le biais des systèmes events et AppleScript
* etc.


## Lancement de l'application

Double-cliquer simplement sur le fichier 'run.rb'. Il est auto-exécutable.

### Aperçu des touches courantes

Par convention, on utilise la touche `C2` (la plus à gauche en démarrant le mini-clavier maitre) pour afficher en console un aperçu de toutes les touches.

## Arrêt de l'application

Pour arrêter l'application, il suffit de jouer en même temps les deux DO à l'octave. Cela ouvre un menu demandant quoi faire, choisir "Finir".


## Définition de la carte des touches

Définir la carte des touches permet de définir les opérations qui seront exécutées lorsqu'une touche est pressée.

<span style="color:red;">ATTENTION</span> : on ne doit pas définir la touche `C2` (première à gauche) qui est réservée pour avoir un aperçu de toutes les touches.

On crée un carte dans le dossier `Maps` de l'application avec l'extension `.yaml` (puisque ce sont des fichiers `YAML`). Et l'on définit chaque touche par :

~~~yaml
---
titre: Titre général de la map (pour la sélectionner)
C3:
  titre: Ceci est la définition de la touche C4 en majuscule
  type:  notice
  content: null
C#3:
  titre: Une autre
  type:  script
  content: path/to/the/script_to_run

~~~

Le `:type` de la touche va définir comment elle sera traitée. On trouve les types suivants :

~~~
type        description          note
------------------------------------------------------------------
clipboard   Pour mettre le :content dans le presse-papier

notice      Simplement pour écrire un texte à l'écran (pour se
            souvenir d'informations, par exemple). Peut être utilisé,
            par exemple, pour définir le contenu de la carte.

url         Pour rejoindre avec Safari l'URL définie dans :content

file        Pour ouvrir le fichier de path :content
            Si 'app:' est définie, c'est l’application avec laquelle
            il faut ouvrir le fichier.

folder      Pour ouvrir le dossier de path :content dans le Finder

~~~



## Visualisation de la carte

Une carte peut-être visualiser dans un navigateur grâce à son fichier HTML produit.

Il suffit de choisir le menu 'visualiser la carte…'
