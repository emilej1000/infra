# Projet Infrastructure Cloud et Big Data

Ce projet contient plusieurs axes de progressions montrant les différents problèmes rencontrés.

## Le dossier projetInfraIP

Celui-ci présente une solution dans laquelle on attribue des adresses IP à chaque container. Cette solution n'a pas pu aboutir à cause de l'infrastructure forcée par docker sur mac, utilisant une machine virtuelle pour créer les containers qui empêche de réaliser un routage correctement.

## Le dossier projetInfra

Ce dernier présente une autre solution, dans lequel le routage se fait par le forwarding de port entre les hôtes physiques et les containers.

La différence à observer entre les deux solutions s'observent surtout dans le main.tf ainsi que l'inventory.ini.

## Le dossier scale-subject

Il contient les programmes et scripts permettant de déployer le wordcount sur l'infrastructure, il s'agit de la solution aboutie en TP Big DATA.

# Mise en place

Avant de déployer l'infrastructure, il est nécessaire de mettre en place une connexion ssh entre les deux hôtes physiques, ainsi que de modifier le fichier inventory pour adapter les ip et users à l'infrastructure. Tout le déploiement se fera ensuite par ansible.

- deploy.yml : premier playbook qui applique la configuration terraform sur les deux hôtes, on aboutit après son déploiement à deux containers sur chaque hôte, master et slave-3 pour l'un, slave-1 et slave-2 pour l'autre. Il s'agit d'images ubuntu permettant la connexion ssh.
- ssh.yml : permet au master d'accéder en ssh aux slaves en distribuant sa clé publique, nécessaire pour déployer le wordcount.
- ssh2.yml : permet à l'hôte déployant les playbooks d'accéder en ssh aux containers en distribuant sa clé publique, nécessaire à l'éxecution de playbooks directement sur les containers.
- ssh3.yml : finalise la mise en place d'ansible en mettant à jour python dans les containers, à partir de cette étape, il est possible de déployer des playbooks directement sur ces derniers.
- setup.yml : ce playbook vise à mettre en place l'environnement pour le déploiment du wordcount, on télécharge toutes les dépendances dont on a besoin et on ajoute les variables d'environnement.

Suite à tout cela, si l'infrastructure sur mac le permettait, il suffirait de suivre les instructions présentes dans "scale-subject" pour déployer le wordcount en mode multi-noeud.