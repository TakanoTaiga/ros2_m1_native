```sh
brew install python@3.10
export PATH=$(brew --prefix)/opt/python@3.10/libexec/bin:$PATH

pip3 install -U catkin_pkg colcon-common-extensions vcstool lark==1.1.1 numpy netifaces

mkdir src
vcs import src < ros2.repos
colcon build --symlink-install --cmake-args \
  -DBUILD_TESTING=OFF \
  -DTHIRDPARTY=FORCE
```
