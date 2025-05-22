FROM idein/actcast-rpi-app-base:bookworm-1 AS builder

ENV DEBIAN_FRONTEND=noninteractive

# Install ROS2 Humble dependencies
# https://krishbin.com.np/blogs/installing-ros2-in-debian-12-bookworm
RUN mkdir -p ~/humble_ws/src \
    && cd ~/humble_ws \
    && wget https://github.com/ros2/ros2/raw/humble/ros2.repos \
    && apt update && apt install curl -y \
    && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu bookworm main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS 2 Humble dependencies
RUN apt update && apt install -y \
    python3-flake8-docstrings \
    python3-pip \
    python3-pytest-cov \
    ros-dev-tools \
    python3-flake8-blind-except \
    python3-flake8-builtins \
    python3-flake8-class-newline \
    python3-flake8-comprehensions \
    python3-flake8-deprecated \
    python3-flake8-import-order \
    python3-flake8-quotes \
    python3-pytest-repeat \
    python3-pytest-rerunfailures \
    python3-cffi

# Install ROS 2 humble
RUN cd ~/humble_ws \
    && vcs import src < ros2.repos \
    && rosdep init \
    && rosdep update \
    && rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers" \
    && colcon build --install-base /opt/ros/install --packages-up-to ros2cli ros2run ros2topic ros2node demo_nodes_py

# 2nd stage: 実行環境の構築
FROM idein/actcast-rpi-app-base:bookworm-1 AS runtime

# 成果物だけコピー
COPY --from=builder /opt/ros/install /opt/ros/install

RUN mkdir -p ~/humble_ws/src \
    && cd ~/humble_ws \
    && wget https://github.com/ros2/ros2/raw/humble/ros2.repos \
    && apt update && apt install curl -y \
    && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu bookworm main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt update && apt install -y \
    python3-flake8-docstrings \
    python3-pip \
    python3-pytest-cov \
    ros-dev-tools \
    python3-flake8-blind-except \
    python3-flake8-builtins \
    python3-flake8-class-newline \
    python3-flake8-comprehensions \
    python3-flake8-deprecated \
    python3-flake8-import-order \
    python3-flake8-quotes \
    python3-pytest-repeat \
    python3-pytest-rerunfailures \
    python3-cffi \
    python3-cairo \
    libspdlog1.10
