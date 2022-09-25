#!/bin/bash
usage() # To show the correct format
{
    echo "Usage: $0 <mode:backup|sync> source_dir target_dir"
}

usage #To tell the userh how to use it 

# If the number of input parameters is not 3, show error!
if [ $# -ne 3 ] ; then  
    if [ $# -lt 3 ] ; then
        echo -n "Missing argument(s)! "
    elif [ $# -gt 3 ] ; then
        echo -n "Too many arguments! "
    fi
    usage
    exit 1
fi

# If the first parameter is not "backup" or "sync", an error will be reported
if [ "$1" != "backup" -a "$1" != "sync" ] ; then  
    echo -n "Mode not recognized. "
    usage
    exit 1
fi

# The input source directory does not exist, an error is reported
if [ ! -d "$2" ] ; then   
    echo "$0: Source dir '$2': No such directory"
    exit 1
fi


mode=$1
src=$2; tgt=$3
# Accept two parameters: source folder, target folder, recursively delete files in the target folder that do not exist in the source folder
rmExtraFiles()  
{
    for file in $2/* ; do   # Traverse all files in the target folder
        if [ ! -e "${file/$2/$1}" ] ; then # If the file does not exist in the source folder, delete it
            rm -rf "$file"
        elif [ -d "$file" ] ; then    #If the file is a directory, recursively perform a check delete operation
            rmExtraFiles "${file/$2/$1}" "$file"
        fi
    done
}

sync() # Synchronize function
{
    [ ! -d "$2" ] && echo "Target directory '$2' does not exist. Creating target dir..." && mkdir -p "$2"   
    rmExtraFiles "$1" "$2"  # First remove the extra files in the target folder
    # Update the destination folder with the files from the source folder (-u: Updated files will only be copied)
    cp -Trup "$1" "$2"
    # Update the source folder with files from the destination folder      
    cp -Trup "$2" "$1"      
}

case $mode in
    backup)     # backup -function
        echo "Backing up $src -> $tgt..." # If the destination directory does not exist, create a new directory
        [ ! -d "$tgt" ] && echo "Target directory '$tgt' does not exist. Creating target dir..." && mkdir -p "$tgt"   
        # copy SRC directory recursively (-r), attribute reserved (-p) to TGT directory (-t: treat DEST as a normal file), and when the source file update/destination directory does not have this file to copy (-u), from this achieve backup function
        cp -Trup "$src" "$tgt" && echo "Backup from $src to $tgt completed!" || (echo "$0: Backup failed"; exit 1)
        ;;
    sync)       # Synchronize function
        echo "Syncing $src <-> $tgt..."
        sync "$src" "$tgt" && echo "Sync $src and $tgt completed!" || (echo "$0: Sync failed"; exit 1)
        ;;
    *) 
        echo -n "$0: Mode error! "
        usage
        exit 1
        ;;
esac
exit 0

