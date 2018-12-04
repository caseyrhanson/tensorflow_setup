# Installing TensorFlow 1.12 on Ubuntu 18.04

Following the example here: https://www.tensorflow.org/install/install_linux

# 1.0 CUDA

## 1.1 Nvidia-Cuda-Toolkit
First we need to download the `nivida-cuda-toolkit`

```
sudo apt install nvidia-cuda-toolkit
```

This will install a lot of files in `/usr` like `/usr/lib/cuda` and `/usr/bin/cuda`. The version here is 9.1, but the cuda version we will install can be < 9.1 (I think).

## 1.2 Install CUDA
Check with the tensorflow website for the version of cuda corresponding to your release. The newest tf release (1.8) is compatible with 9.0. 

Head to https://developer.nvidia.com/cuda-toolkit-archive and find the latest release corresponding to your target cuda version.

For this tutorial, I will choose `CUDA Toolkit 9.0 (Sept 2017)` which links to here: https://developer.nvidia.com/cuda-90-download-archive

For this exercise, we selected the following `Linux x86_64 Ubuntu 1704 deblocal`. The reason we chose 17.04 and not 18.04, is because at the time of this tutorial it wasn't available. The links is below:
https://developer.nvidia.com/cuda-90-download-archive?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1704&target_type=deblocal

This will take you to a page with a base installer and instructions, and possibly (in this case 4) patches. Go ahead and download all debian packages.

You will then want to add the packages via `dpkg -i`. You will also want to install the cuda key which the website gives you as well as the `dpkg` output for the base cuda package.

```
sudo dpkg -i cuda-repo-ubuntu1704-9-0-local_9.0.176-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1704-9-0-local-cublas-performance-update_1.0-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1704-9-0-local-cublas-performance-update-2_1.0-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1704-9-0-176-local-patch-4_1.0-1_amd64.deb 
sudo dpkg -i cuda-repo-ubuntu1704-9-0-local-cublas-performance-update-3_1.0-1_amd64.deb 
sudo apt-key add /var/cuda-repo-<version>/7fa2af80.pub
sudo apt-get update && sudo apt-get install cuda
```

Without the `nvidia-cuda-toolkit`, this step failed in the past.

## 1.3 Environment Variables and Misc

Following the tensorflow instructions, head to https://docs.nvidia.com/cuda/cuda-installation-guide-linux/ and make sure you haven't missed any steps.

Put the following in your .bashrc
```
export CUDA_HOME='/usr/local/cuda`
```

# 2.0 cuDNN

## 2.1 Install cuDNN 7.4.1

To install `cudnn` head to https://developer.nvidia.com/rdp/cudnn-archive (login and everything) and check out the cuDNN version corresponding to your version of tensorflow. For us, that is v7.0. Find the link to the latest v7.0.x version for your CUDA version (9.0).

From the drop down menu:

Go ahead and download all ubuntu debian packages (they only have 16.04 packages for runtime and development):
1. cuDNN v7.4.1 Runtime Library for Ubuntu16.04 (Deb): https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.4.1.5/prod/9.0_20181108/Ubuntu16_04-x64/libcudnn7_7.4.1.5-1%2Bcuda9.0_amd64.deb
2. cuDNN v7.4.1 Developer Library for Ubuntu16.04 (Deb): https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.4.1.5/prod/9.0_20181108/Ubuntu16_04-x64/libcudnn7-dev_7.4.1.5-1%2Bcuda9.0_amd64.deb
3. cuDNN v7.4.1 Code Samples and User Guide for Ubuntu16.04 (Deb): https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.4.1.5/prod/9.0_20181108/Ubuntu16_04-x64/libcudnn7-doc_7.4.1.5-1%2Bcuda9.0_amd64.deb

Open the Install guide (https://docs.nvidia.com/deeplearning/sdk/cudnn-install/index.html) and goto the appropriate section for local debian packages on Ubuntu.

Basically, do `dpkg -i` on each of the downloaded cuDNN debian packages. Note the actual filenames may differ from the installation guide.

```
sudo dpkg -i libcudnn7_7.4.1.5-1+cuda9.0_amd64.deb      
sudo dpkg -i libcudnn7-dev_7.4.1.5-1+cuda9.0_amd64.deb 
sudo dpkg -i libcudnn7-doc_7.4.1.5-1+cuda9.0_amd64.deb 
```

Note that after -dev, i got this note. I'm not sure what to do with it.
`update-alternatives: using /usr/include/x86_64-linux-gnu/cudnn_v7.h to provide /usr/include/cudnn.h (libcudnn) in auto mode`.
## 2.1 Verify cuDNN

The TensorFlow website says to set `$CUDA_HOME`, but we did that in the last section.

What we will do here is follow section 2.4 of the cuDNN Installation Guide:

In a place of your choice (we choose `$HOME`), do the following:
```
sudo cp -r /usr/src/cudnn_samples_v7/ $HOME
cd $HOME/cudnn_samples_v7/mnistCUDNN
make clean && make
./mnistCUDNN
```

It should return `Test passed`.

You might see something regarding the version of GCC > 6, like this:
```
In file included from /usr/local/cuda/bin/..//include/host_config.h:50:0,
                 from /usr/local/cuda/bin/..//include/cuda_runtime.h:78,
                 from <command-line>:0:
/usr/local/cuda/bin/..//include/crt/host_config.h:119:2: error: #error -- unsupported GNU version! gcc versions later than 6 are not supported!
 #error -- unsupported GNU version! gcc versions later than 6 are not supported!
 ```
This was the case for me and it can be fixed by updating a sym link to another version of gcc. You might need to install gcc-6 though.

```
sudo apt install gcc-6 g++-6
sudo ln -s /usr/bin/gcc-6 /usr/local/cuda/bin/gcc 
sudo ln -s /usr/bin/g++-6 /usr/local/cuda/bin/g++
```
HatTip to https://devtalk.nvidia.com/default/topic/1032269/cuda-9-gcc-7-compatibility-with-nvcc/ ,which I found after a lot of Googling. The test should pass after this.

# 3.0 GPU Card and Drivers

Just Make sure your GPU card meets the compatibility requirements and you have installed the correct GPU drivers. Ubuntu Software & Update can let you change the driver to Nvidia's propietary. You can also do this on the command line.

TensorFlow also says to do this but it didn't work, and I didn't notice it being consequential. It's probably redundant with nvidia-cuda-toolkit

```
sudo apt-get install cuda-command-line-tools
```

## 3.1 *Optional: NVIDIA TensorRT 3.0 Fast*

TensorFlow says you can do the following to increase inference speed (don't worry about it being 14.04, TensorFlow claims):

```
wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1404/x86_64/nvinfer-runtime-trt-repo-ubuntu1404-3.0.4-ga-cuda9.0_1.0-1_amd64.deb
sudo dpkg -i nvinfer-runtime-trt-repo-ubuntu1404-3.0.4-ga-cuda9.0_1.0-1_amd64.deb
sudo apt-get update
sudo apt-get install -y --allow-downgrades libnvinfer-dev libcudnn7-dev=7.0.5.15-1+cuda9.0 libcudnn7=7.0.5.15-1+cuda9.0
```
To avoid cuDNN version conflicts during later system upgrades, you can hold the cuDNN version at 7.0.5 (I did this):

```
sudo apt-mark hold libcudnn7 libcudnn7-dev
```
To later allow upgrades, you can remove the hold:

```
sudo apt-mark unhold libcudnn7 libcudnn7-dev
```

# 4.0 TensorFlow

I chose to install TensorFlow via pip on python 3.6. To update python3 for this, do the following:

```
sudo apt-get install python3-pip python3-dev
```

Install TensorFlow by doing one of the following:

## 4.1 pip3 install
```
pip3 install tensorflow-gpu 
```

## 4.2 Download pre-built code and install

If 4.1 failed, go to this location and find the matching URL for your python installation and CPU/GPU situation.

https://www.tensorflow.org/install/install_linux#the_url_of_the_tensorflow_python_package

For me, it was 3.6 GPU.

Then download the file from the url and upgrade from the file.

```
sudo pip3 install --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.8.0-cp36-cp36m-linux_x86_64.whl
```

*Note: I believe I did both 4.1 and 4.2. This is not necessary, I think.*

If you have other problems, go here https://www.tensorflow.org/install/install_linux#common_installation_problems

# 5.0 Verify TensorFlow

Open python3

```
python3
```

In python3, import tensorflow and print the version

```python
import tensorflow as tf
print(tf.__version__)
```

You should see 1.8. If so, execute the following program:

```python
import tensorflow as tf
# Creates a graph.
a = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[2, 3], name='a')
b = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[3, 2], name='b')
c = tf.matmul(a, b)
# Creates a session with log_device_placement set to True.
sess = tf.Session(config=tf.ConfigProto(log_device_placement=True))
# Runs the op
print(sess.run(c))
sess.close()
```

You should see the following:
[[22. 28.]
 [49. 64.]]

In addition, you might see a bunch of logging like below. Just make sure your gpu is being used.
```
 Your CPU supports instructions that this TensorFlow binary was not compiled to use: AVX2 FMA
2018-06-04 18:58:30.204701: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:898] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2018-06-04 18:58:30.205036: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1356] Found device 0 with properties: 
name: GeForce GTX 1080 major: 6 minor: 1 memoryClockRate(GHz): 1.7335
pciBusID: 0000:01:00.0
totalMemory: 7.93GiB freeMemory: 7.38GiB
2018-06-04 18:58:30.205048: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1435] Adding visible gpu devices: 0
2018-06-04 18:58:30.353875: I tensorflow/core/common_runtime/gpu/gpu_device.cc:923] Device interconnect StreamExecutor with strength 1 edge matrix:
2018-06-04 18:58:30.353906: I tensorflow/core/common_runtime/gpu/gpu_device.cc:929]      0 
2018-06-04 18:58:30.353910: I tensorflow/core/common_runtime/gpu/gpu_device.cc:942] 0:   N 
2018-06-04 18:58:30.354052: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1053] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 7127 MB memory) -> physical GPU (device: 0, name: GeForce GTX 1080, pci bus id: 0000:01:00.0, compute capability: 6.1)
Device mapping:
/job:localhost/replica:0/task:0/device:GPU:0 -> device: 0, name: GeForce GTX 1080, pci bus id: 0000:01:00.0, compute capability: 6.1
2018-06-04 18:58:30.409297: I tensorflow/core/common_runtime/direct_session.cc:284] Device mapping:
/job:localhost/replica:0/task:0/device:GPU:0 -> device: 0, name: GeForce GTX 1080, pci bus id: 0000:01:00.0, compute capability: 6.1

>>> # Runs the op
... print(sess.run(c))
MatMul: (MatMul): /job:localhost/replica:0/task:0/device:GPU:0
2018-06-04 18:58:30.409821: I tensorflow/core/common_runtime/placer.cc:886] MatMul: (MatMul)/job:localhost/replica:0/task:0/device:GPU:0
b: (Const): /job:localhost/replica:0/task:0/device:GPU:0
2018-06-04 18:58:30.409829: I tensorflow/core/common_runtime/placer.cc:886] b: (Const)/job:localhost/replica:0/task:0/device:GPU:0
a: (Const): /job:localhost/replica:0/task:0/device:GPU:0
2018-06-04 18:58:30.409834: I tensorflow/core/common_runtime/placer.cc:886] a: (Const)/job:localhost/replica:0/task:0/device:GPU:0
[[22. 28.]
 [49. 64.]]
 ```












