## Test env

- M1 Max 64GB MacBook Pro
- macOS 13.5.2 (22G91)

## How to install

### Install brew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Execute the command mentioned at the end of the brew installation here**

```bash
# example
echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/hoge/.zprofile
eval $(/opt/homebrew/bin/brew shellenv)
```

```bash
brew install \
    asio assimp bison bullet cmake console_bridge cppcheck \
    cunit eigen freetype graphviz opencv openssl orocos-kdl pcre poco \
    pyqt5 python qt@5 sip spdlog tinyxml tinyxml2 wget
```

```bash
brew uninstall --ignore-dependencies python@3.12 qt6
```

```bash
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
```

```bash
git clone https://github.com/TakanoTaiga/ros2_m1_native.git
cd ros2_m1_native
mkdir src
vcs import src < ros2.repos
```

```bash
patch -l < patches/ros2_console_bridge_vendor.patch
patch -l < patches/ros2_rviz_ogre_vendor.patch
```

```bash
export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$(brew --prefix qt@5)
export PATH=$PATH:$(brew --prefix qt@5)/bin
export COLCON_EXTENSION_BLOCKLIST=colcon_core.event_handler.desktop_notification
python3.11 -m colcon build --symlink-install --cmake-args \
            -DBUILD_TESTING=OFF \
            -DTHIRDPARTY=FORCE \
            -DCMAKE_BUILD_TYPE=Release \
            -Wno-dev
```

## Write to .zshrc

```bash
source ~/Documents/ros2_m1_native/install/setup.zsh
export ROS_VERSION=2
export ROS_PYTHON_VERSION=3
export ROS_DISTRO=humble
```

`source ~/Documents/ros2_m1_native/install/setup.zsh` is an example if you have used `git clone` within the Documents directory. If it's in the home directory, it would be `source ~/ros2_m1_native/[so on]`.

## Quick run

```bash
# terminal 1
ros2 run demo_nodes_cpp talker
```

```bash
# terminal 2
ros2 run demo_nodes_py listener
```
