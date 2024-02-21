#!/bin/bash

##########################################################
# Script: interactive_file_search.sh
# Descripción: Este script interactivo permite buscar archivos en el sistema.
# Autor: Jose Garagorry <jj@softraincorp.com>
##########################################################

# Mensaje de advertencia sobre los atributos de usuario
echo "Este script trabaja en base a los atributos del usuario que lo está ejecutando."

# Preguntar desde dónde se va a hacer la búsqueda
read -p "¿Desde qué directorio desea realizar la búsqueda? " search_dir

# Preguntar el nombre del archivo
read -p "Ingrese el nombre (o patrón) del archivo a buscar: " file_name

# Indicar que la búsqueda es sensible a mayúsculas y minúsculas
echo "La búsqueda será sensible a mayúsculas y minúsculas."

# Preguntar por qué atributo desea realizar la búsqueda
echo "Por favor, seleccione el atributo por el cual desea buscar:"
echo "1. Nombre (name)"
echo "2. Nombre insensible a mayúsculas y minúsculas (iname)"
echo "3. Inodo (inode)"
echo "4. Permisos (perm)"
echo "5. Tipo (type)"
echo "6. Tiempo de modificación (time)"
echo "7. Tiempo de acceso (atime)"
echo "8. Tiempo de creación (ctime)"
read -p "Opción: " search_attribute

# Realizar la búsqueda y contar los archivos encontrados
case $search_attribute in
    1) search_command="find \"$search_dir\" -type f -name \"$file_name\"";;
    2) search_command="find \"$search_dir\" -type f -iname \"$file_name\"";;
    3) search_command="find \"$search_dir\" -type f -inum \"$file_name\"";;
    4) search_command="find \"$search_dir\" -type f -perm \"$file_name\"";;
    5) search_command="find \"$search_dir\" -type \"$file_name\"";;
    6) search_command="find \"$search_dir\" -type f -mtime \"$file_name\"";;
    7) search_command="find \"$search_dir\" -type f -atime \"$file_name\"";;
    8) search_command="find \"$search_dir\" -type f -ctime \"$file_name\"";;
    *) echo "Opción no válida"; exit 1;;
esac

# Ejecutar la búsqueda y obtener los resultados
search_results=$(eval "$search_command")
num_files=$(echo "$search_results" | wc -l)

# Mostrar los archivos encontrados
echo "Se encontraron $num_files archivos:"
echo "$search_results"

# Preguntar qué acción realizar con los archivos encontrados
read -p "¿Qué desea hacer con los archivos encontrados? (borrar/listar/contar/consumo): " action

# Realizar la acción seleccionada
case $action in
    borrar)
        echo "Borrando los archivos encontrados..."
        rm -i $search_results;;
    listar)
        echo "Listando los archivos encontrados..."
        ls -l $search_results;;
    contar)
        echo "Contando los archivos encontrados..."
        echo "$num_files archivos encontrados.";;
    consumo)
        echo "Determinando el consumo de los archivos encontrados..."
        total_size=$(du -ch $search_results | grep "total$" | awk '{print $1}')
        echo "El consumo total de los archivos es de $total_size.";;
    *)
        echo "Acción no válida"; exit 1;;
esac


