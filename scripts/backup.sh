#!/bin/bash
docker run --rm --volumes-from minecraft-server -v $(pwd):/backup busybox tar cvf /backup/backup.tar /data