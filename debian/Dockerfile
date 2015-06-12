FROM debian:jessie
MAINTAINER Arnaud Gelas "arnaudgelas@gmail.com"

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y bash \
  bash-completion \
  build-essential \
  cmake-curses-gui \
  qt5-default \
  qt5-qmake \
  libhdf5-dev \
  libboost-all-dev \
  libcgal-dev \
  ninja-build \
  git-core \
  ccache \
  vim \
  # extra package needed to build vtk
  libxt-dev \
  libhdf5-dev \
  libfreetype6-dev \
  libjsoncpp-dev \
  libxml2-dev \
  libtiff5-dev \
  qttools5-dev \
  libqt5webkit5-dev \
  libnetcdf-dev \
  libgl2ps-dev \
  libtheora-dev \
  libogg-dev \
  # extra package needed to build gdcm
  libpoppler-private-dev \
  libopenjpeg-dev \
  libssl-dev \
  uuid-dev \
  libjson0-dev \
  openjpip-dec-server \
  libcharls-dev \
  libsocket++-dev \
  # extra package needed to build statismo
  libeigen3-dev

RUN mkdir -p /usr/install

ENV INSTALL_DIR /usr/install
ENV CROSS_TRIPLE x86_64-linux-gnu
ENV CROSS_ROOT /usr/${CROSS_TRIPLE}
ENV PATH ${PATH}:${CROSS_ROOT}/bin:${INSTALL_DIR}
ENV LD_LIBRARY_PATH ${CROSS_ROOT}/lib:${LD_LIBRARY_PATH}

RUN mkdir -p vtk-build gdcm-build itk-build statismo-build acvd-build

WORKDIR /usr/src
RUN git clone https://gitlab.kitware.com/vtk/vtk.git vtk
WORKDIR /usr/src/vtk
RUN git checkout v6.2.0

WORKDIR /usr/src/vtk-build

RUN cmake -G Ninja \
  -DVTK_Group_Qt:BOOL=ON \
  -DVTK_QT_VERSION:STRING=5 \
  -DVTK_USE_OFFSCREEN:BOOL=ON \
  -DVTK_USE_SYSTEM_LIBRARIES:BOOL=ON \
  -DVTK_Group_Imaging:BOOL=ON \
  -DVTK_Group_Rendering:BOOL=ON \
  -DVTK_Group_Views:BOOL=ON \
  -DVTK_USE_SYSTEM_HDF5:BOOL=ON \
  -DVTK_USE_SYSTEM_LIBPROJ4:BOOL=OFF \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DBUILD_TESTING:BOOL=OFF \
  -DBUILD_EXAMPLES:BOOL=OFF \
  -DBUILD_SHARED_LIBS:BOOL=ON \
  /usr/src/vtk
RUN ninja
RUN ninja install

WORKDIR /usr/src
RUN git clone git://git.code.sf.net/p/gdcm/gdcm gdcm
WORKDIR /usr/src/gdcm
RUN git checkout release
WORKDIR /usr/src/gdcm-build
RUN cmake -G Ninja \
  -DGDCM_BUILD_SHARED_LIBS:BOOL=ON \
  -DGDCM_BUILD_EXAMPLES:BOOL=OFF \
  -DGDCM_BUILD_TESTING:BOOL=OFF \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
  -DGDCM_BUILD_APPLICATIONS:BOOL=OFF \
  -DGDCM_USE_VTK:BOOL=ON  \
  -DGDCM_USE_SYSTEM_CHARLS:BOOL=ON \
  -DGDCM_USE_SYSTEM_EXPAT:BOOL=ON \
  -DGDCM_USE_SYSTEM_JSON:BOOL=ON \
  -DGDCM_USE_SYSTEM_LIBXML2:BOOL=ON \
  -DGDCM_USE_SYSTEM_OPENJPEG:BOOL=ON \
  -DGDCM_USE_SYSTEM_OPENSSL:BOOL=ON \
  -DGDCM_USE_SYSTEM_POPPLER:BOOL=ON \
  -DGDCM_USE_SYSTEM_SOCKETXX:BOOL=ON \
  -DGDCM_USE_SYSTEM_UUID:BOOL=ON \
  -DGDCM_USE_SYSTEM_ZLIB:BOOL=ON \
  /usr/src/gdcm
RUN ninja
RUN ninja install

WORKDIR /usr/src
RUN git clone git://itk.org/ITK.git itk
WORKDIR /usr/src/itk-build
RUN cmake -G Ninja \
  -DBUILD_EXAMPLES:BOOL=OFF \
  -DBUILD_SHARED_LIBS:BOOL=ON \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
  -DITK_BUILD_DEFAULT_MODULES:BOOL=ON \
  -DModule_ITKVtkGlue:BOOL=ON \
  -DBUILD_TESTING:BOOL=OFF \
  -DITK_USE_64BITS_IDS:BOOL=ON \
  -DITK_USE_STRICT_CONCEPT_CHECKING:BOOL=ON \
  -DITK_USE_SYSTEM_EXPAT:BOOL=ON \
  -DITK_USE_SYSTEM_FFTW:BOOL=ON \
  -DITK_USE_SYSTEM_GDCM:BOOL=ON \
  -DITK_USE_SYSTEM_HDF5:BOOL=ON \
  -DITK_USE_SYSTEM_JPEG:BOOL=ON \
  -DITK_USE_SYSTEM_LIBRARIES:BOOL=ON \
  /usr/src/itk
RUN ninja
RUN ninja install

WORKDIR /usr/src
RUN git clone https://github.com/statismo/statismo.git statismo
RUN mkdir -p statismo-build acvd-build
WORKDIR /usr/src/statismo-build
RUN cmake -G Ninja \
  -DBUILD_SHARED_LIBS:BOOL=ON \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
  -DVTK_SUPPORT:BOOL=ON \
  -DITK_SUPPORT:BOOL=ON \
#  -DITK_DIR:PATH=${INSTALL_DIR}/lib/cmake/ITK-4.8 \
  -DBUILD_TESTING:BOOL=OFF \
  -DBUILD_EXAMPLES:BOOL=OFF \
  -DBUILD_CLI_TOOLS:BOOL=ON \
  /usr/src/statismo
RUN ninja
RUN ninja install

WORKDIR /usr/src
RUN git clone https://github.com/valette/ACVD.git acvd
WORKDIR /usr/src/acvd
RUN git checkout vtk6
WORKDIR acvd-build
RUN cmake -G Ninja \
  -DBUILD_EXAMPLES:BOOL=OFF \
  -DBUILD_SHARED_LIBS:BOOL=ON \
  -DBUILD_VOLUMEPROCESSING:BOOL=OFF \
  -DBUILD_SHARED_LIBS:BOOL=ON \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
  /usr/src/acvd
RUN ninja
RUN ninja install

WORKDIR /usr/src
RUN rm -rf vtk* itk* statismo* acvd* gdcm*

# -DVTK_USE_64BIT_IDS:BOOL=ON
