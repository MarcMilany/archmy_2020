#!/bin/bash
# Пример скрипта: автоматическое резервное копирование Dropbox
# Вот пример скрипта, который можно использовать для автоматического резервного копирования каталога в Dropbox:

# Set the source and destination directories
SOURCE_DIR="/path/to/source"
DEST_DIR="/path/to/destination"

# Sync the directories using rsync
rsync -av --delete "$SOURCE_DIR" "$DEST_DIR"

# Check the Dropbox status
DROPBOX_STATUS=$(dropbox status)

# If Dropbox is running, wait for synchronization to complete
if [[ $DROPBOX_STATUS == *"Up to date"* ]]; then
  echo "Dropbox is up to date. Backup complete."
else
  echo "Waiting for Dropbox synchronization to complete..."
  dropbox wait
  echo "Dropbox synchronization complete. Backup complete."
fi
