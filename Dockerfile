FROM ros:humble-ros-base

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=humble

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    socat \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /ros2_ws

RUN mkdir -p src

COPY dynamixel_hardware src/dynamixel_hardware
COPY open_manipulator_x_description src/open_manipulator_x_description
COPY pantilt_bot_description src/pantilt_bot_description

RUN rosdep update && \
    apt-get update && \
    rosdep install \
        --from-paths src \
        --ignore-src \
        -r \
        -y \
        --rosdistro ${ROS_DISTRO} && \
    rm -rf /var/lib/apt/lists/*

RUN source /opt/ros/${ROS_DISTRO}/setup.bash && \
    colcon build --symlink-install

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /root/.bashrc && \
    echo "source /ros2_ws/install/setup.bash" >> /root/.bashrc

CMD ["bash"]