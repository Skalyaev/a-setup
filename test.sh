#!/bin/bash

# Initialiser un tableau pour stocker les arguments d'exclusion
exclude_args=()

# Pour chaque répertoire à exclure donné en paramètre
for dir in "$@"; do
    # Ajouter les conditions d'exclusion au tableau
    exclude_args+=(! -path "*/$1/*")
done

# Utiliser find avec les arguments d'exclusion générés et chercher les fichiers 'apt.list'
find . "${exclude_args[@]}" -type f -name 'apt.list'

