# kf2-dedicated
Learning to make a KF2 Server in Docker

sudo mkdir -p $(pwd)/kf2-data

sudo chmod 777 $(pwd)/kf2-data

docker build --network host -t kf2-dedicated $(pwd)/kf2_dedicated_docker

docker run -d --net=host -v $(pwd)/kf2-data:/home/steam/kf2-dedicated/ --name=kf2-dedicated kf2-dedicated:latest


For editing files, use the volume you created when doing docker run

For more information on server settings: https://wiki.killingfloor2.com/index.php?title=Dedicated_Server_(Killing_Floor_2)

