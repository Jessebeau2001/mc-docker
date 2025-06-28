# Dockerized Minecraft - The Scuffed Version
Environment for containerizing minecraft servers. This primarily exists to isolate java versions and have the server be able to gracefully shutdown on machine shutdown.

# How to run
To create and start the server container run  
```docker compose --profile server up```

To create a backup run  
```docker compose --profile backup up```