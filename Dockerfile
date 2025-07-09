FROM ros:rolling-ros-core-noble

RUN apt update && apt install -y \
    sudo \
    curl \
    wget \
    vim \
    git \
    python3-pip \
    python3-vcstool \
    python3-rosdep \
    xvfb \
    htop \
    mesa-utils \
    libgl1 \
    libglx-mesa0 \
    ros-dev-tools \
    xdg-utils \
    software-properties-common \
    apt-transport-https \
    gpg \
    openjdk-11-jre \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep init 

## Create ubuntu-user user, disable password, and add it to sudo group
RUN groupadd -g 1001 plansys-user \
    && adduser --disabled-password --gid 1001 --uid 1001 --gecos '' plansys-user \
    && adduser plansys-user sudo

RUN echo 'plansys-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
ENV HOME=/home/plansys-user
USER plansys-user
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR $HOME

WORKDIR $HOME/plansys2_ws/src
RUN git clone https://github.com/PlanSys2/ros2_planning_system.git

WORKDIR $HOME/plansys2_ws
RUN vcs import --input src/ros2_planning_system/dependency_repos.repos src/

RUN ["/bin/bash", "-c", "source /opt/ros/rolling/setup.bash \
    && sudo apt update \
    && rosdep update \
    && rosdep install --from-paths src --ignore-src -r -y \
    && sudo rm -rf /var/lib/apt/lists/"]

RUN ["/bin/bash", "-c", "source /opt/ros/rolling/setup.bash \
    && colcon build --symlink-install \
    && echo 'source ~/plansys2_ws/install/setup.bash' >> ~/.bashrc"]