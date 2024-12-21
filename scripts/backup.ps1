# Get the current working directory
$currentDir = Get-Location

# Run the Docker command to backup the container's data
docker run --rm --volumes-from minecraft-server -v "$($currentDir.Path):/backup" busybox tar cvf /backup/backup.tar /minecraft/server
