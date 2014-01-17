#!/bin/sh

# A bash script for syncing my Sublime Text 3 (also known as ST3) configuration
# using Dropbox.

DROPBOX="$HOME/Dropbox"
read -p "Using $DROPBOX for DropBox folder location. Press ENTER to accept or CTRL-C to abort."


# Where do we put Sublime settings in our Dropbox
SYNC_FOLDER="$DROPBOX/ST3"
read -p "Using $SYNC_FOLDER to store settings on DropBox. Press ENTER to accept or CTRL-C to abort."

# Where Sublime settings have been installed
if [ `uname` = "Darwin" ];then
        SOURCE="$HOME/Library/Application Support/Sublime Text 3"
        echo "Operating system detected as Darwin. Using $SOURCE as the settings location."
elif [ `uname` = "Linux" ];then
        SOURCE="$HOME/.config/sublime-text-3"
        echo "Operating system detected as Linux. Using $SOURCE as the settings location."
else
        echo "Unknown operating system! Exiting..."
        exit 1
fi

# Check that settings really exist on this computer
if [ ! -e "$SOURCE/Packages/" ]; then
        echo "Could not find $SOURCE/Settings/"
        echo "Aborting..."
        exit 1
else
        echo "Found the $SOURCE/Settings/ directory."
fi

# Detect that we don't try to install twice and screw up
if [ -L "$SOURCE/Packages" ] ; then
        echo ""
        echo "Dropbox settings already symlinked! Aborting..."
        exit 1
else
        echo ""
        echo "Dropbox settings NOT already symlinked. Proceeding..."
fi

# Dropbox has not been set-up on any computer before?
if [ ! -e "$SYNC_FOLDER" ] ; then
        echo "This is the first time you have run this script for this DropBox account!"
        echo "Creating the $SYNC_FOLDER and related directories in your $DROPBOX folder."
        read -p "Press [enter] key to continue, or CTRL+C to exit..."

        # Creating the folders in separated categories
        mkdir -p "$SYNC_FOLDER/Installed Packages"
        mkdir -p "$SYNC_FOLDER/Packages"
        # mkdir -p "$SYNC_FOLDER/Settings"

        # Copy the files into their respective folder
        cp -r "$SOURCE/Installed Packages/" "$SYNC_FOLDER/Installed Packages"
        cp -r "$SOURCE/Packages/" "$SYNC_FOLDER/Packages"
        # cp -r "$SOURCE/Settings/" "$SYNC_FOLDER/Settings"
        echo "Successfully copied to DropBox!"
fi

# Now when settings are in Dropbox delete existing files
echo "About to delete the original Sublime Text 3 folders."
read -p "Press [enter] key to continue, or CTRL+C to exit..."
rm -rf "$SOURCE/Installed Packages"
rm -rf "$SOURCE/Packages"

# Symlink settings folders from Drobox
echo "About to create symlinks that point to DropBox."
read -p "Press [enter] key to continue, or CTRL+C to exit..."
ln -s "$SYNC_FOLDER/Installed Packages" "$SOURCE/Installed Packages"
ln -s "$SYNC_FOLDER/Packages" "$SOURCE/Packages"
