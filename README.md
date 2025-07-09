# plansys-docker
Docker file for Plansys rolling. Useful for developing Plansys without the rolling OS

## Build

```Bash
docker build -t plansys .
```

## Run

```Bash
docker run -it --rm --gpus all --runtime=nvidia --name plansys -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 -e NVIDIA_VISIBLE_DEVICES=all -e NVIDIA_DRIVER_CAPABILITIES=all -v $HOME/plansys_ws/src/ros2_planning_system:/home/plansys-user/plansys2_ws/src/ros2_planning_system -v /dev/dri:/dev/dri -v /tmp/.X11-unix:/tmp/.X11-unix -v /etc/localtime:/etc/localtime:ro plansys
```

## Run tests

```Bash
colcon test --event-handlers console_cohesion+ --packages-up-to plansys2
```