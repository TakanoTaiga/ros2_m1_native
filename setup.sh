#!/bin/bash

cd $HOME

# Check if brew is installed.
if [[ -z "$(brew --version)" ]] ; then
    echo "brew is not insalled."
    exit 1
fi

# install dep at brew
brew install \
    asio assimp bison bullet cmake console_bridge cppcheck \
    cunit eigen freetype graphviz opencv openssl orocos-kdl pcre poco \
    pyqt5 python qt@5 sip spdlog tinyxml tinyxml2 wget
brew uninstall --ignore-dependencies python@3.12 qt6

# install dep at pip
python3.11 -m pip install -U pip
python3.11 -m pip install --global-option=build_ext \
       --global-option="-I$(brew --prefix graphviz)/include/" \
       --global-option="-L$(brew --prefix graphviz)/lib/" \
       pygraphviz
python3.11 -m pip install -U \
      argcomplete catkin_pkg colcon-common-extensions coverage \
      cryptography empy==3.3.4 flake8 flake8-blind-except==0.1.1 flake8-builtins \
      flake8-class-newline flake8-comprehensions flake8-deprecated \
      flake8-docstrings flake8-import-order flake8-quotes \
      importlib-metadata lark==1.1.1 lxml matplotlib mock mypy==0.931 netifaces \
      nose pep8 psutil pydocstyle pydot pygraphviz pyparsing==2.4.7 \
      pytest-mock rosdep rosdistro setuptools==59.6.0 vcstool

# clone ros2_m1_native
git clone https://github.com/TakanoTaiga/ros2_m1_native.git
mkdir ${HOME}/ros2_m1_native/src
cd ${HOME}/ros2_m1_native/

patch -l < patches/ros2_console_bridge_vendor.patch
patch -l < patches/ros2_rviz_ogre_vendor.patch

# build ros2_m1_native
export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$(brew --prefix qt@5)
export PATH=$PATH:$(brew --prefix qt@5)/bin
export COLCON_EXTENSION_BLOCKLIST=colcon_core.event_handler.desktop_notification
python3.11 -m colcon build --symlink-install --cmake-args \
            -DBUILD_TESTING=OFF \
            -DTHIRDPARTY=FORCE \
            -DCMAKE_BUILD_TYPE=Release \
            -Wno-dev


echo "source ~/ros2_m1_native/install/setup.zsh" >> ~/.zshrc
echo "export ROS_VERSION=2" >> ~/.zshrc
echo "export ROS_PYTHON_VERSION=3" >> ~/.zshrc
echo "export ROS_DISTRO=humble" >> ~/.zshrc


source ~/ros2_m1_native/install/setup.zsh
export ROS_VERSION=2
export ROS_PYTHON_VERSION=3
export ROS_DISTRO=humble
