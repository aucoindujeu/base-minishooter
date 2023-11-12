# Mini Shooter (squelette)

Base de jeu, shoot’em up minimaliste.

Il se joue au clavier (flèches directionnelles pour déplacer le vaisseau - il y a un brin d’inertie ;) - et barre espace pour tirer).

À améliorer (graphismes, sons, etc.) ou simplement  modifier sans vergogne ! 
Piste d’amélioration, en fonction de votre niveau :

- Trouver ou créer un meilleur son pour l’explosion (pourquoi pas une explosion différente pour les destructions avec les tirs, et avec abordages), ajouter des sons pour les tirs, les accélérations... régler le bug qui fait que les sons ne se « chevauchent pas ». Les fichiers sons se trouvent dans le dossier [src/son/](https://github.com/aucoindujeu/base-minishooter/tree/main/src/sons)

- Améliorer les graphismes : image de fond, sprites des vaisseaux, des tirs... ajouter des petites animations (lors des tirs, lors des explosions, moteur...), faire un scrolling sur plusieurs plans. Les fichiers images des sprites, du fond, etc. se trouvent dans le dossier [src/images/](https://github.com/aucoindujeu/base-minishooter/tree/main/src/images)

- Améliorer les écrans de démarrages et de *game over* : changer la police, ajouter des images, ajouter du texte, un titre, des explications. Trouver ou composer des musiques d’intro ou d’outro, des bruitages ou un jingle de lancement. La police de carcatère se trouve dans le dossier [src/fontes](https://github.com/aucoindujeu/base-minishooter/tree/main/src/fontes)

- Modifier le gameplay. Modifier la maniabilité du vaisseau (ajouter de l’adhérence pour limiter l’effet « savonnette »), créer différents types d’ennemis (trajectoire, résistance, ils peuvent tirer aussi...), des options/bonus...

Créé pour servir de support lors des ateliers « Code Club » du [Cimelab](https://www.aucoindujeu05.fr/fablab/) à Briançon.

## Usage
<!-- TODO -->

Pour lancer le jeu :

        make play

En faire une version exécutable sur le web (avec love.js) : 

        make js


## Licence

Ce projet est distribué d'après les termes de la licence [GNU AGPL version 3](./LICENSE.txt). Même si vous n'en avez pas l'obligation, merci de bien vouloir mentionner que le projet a été initialement créé par la ludothèque de Briançon [Au Coin du Jeu](https://www.aucoindujeu05.fr/) ☺️