FROM fedora:latest
MAINTAINER Arnaud Gelas "arnaudgelas@gmail.com"

RUN dnf update -y
RUN dnf install -y cmake \
  ccache \
  git \
  make  \
  gcc \
  gcc-c++

RUN mkdir -p /usr/install

ENV INSTALL_DIR /usr/install
ENV CROSS_TRIPLE x86_64-linux-gnu
ENV CROSS_ROOT /usr/${CROSS_TRIPLE}
ENV PATH ${PATH}:${CROSS_ROOT}/bin:${INSTALL_DIR}
ENV LD_LIBRARY_PATH ${CROSS_ROOT}/lib:${LD_LIBRARY_PATH}
WORKDIR /usr/src

RUN mkdir -p vtk-build gdcm-build itk-build statismo-build acvd-build

RUN git clone https://gitlab.kitware.com/vtk/vtk.git vtk
WORKDIR /usr/src/vtk
RUN git checkout v6.2.0

WORKDIR /usr/src/vtk-build

RUN dnf install -y ninja-build zlib-devel hdf5-devel freetype-devel jsoncpp-devel expat-devel libjpeg-devel libpng-devel libtiff-devel libX11-devel libXt-devel libXext-devel libGL-devel gl2ps-devel libxml2-devel libtheora-devel
RUN dnf install -y qt5-qtwebkit qt5-qtbase
RUN dnf install -y qt5-qttools qt5-qtwebkit-devel
RUN dnf install -y qt5-qttools-devel
RUN dnf install -y netcdf-cxx-devel

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
RUN ninja-build
RUN ninja-build install

WORKDIR /usr/src
RUN git clone git://git.code.sf.net/p/gdcm/gdcm gdcm
WORKDIR /usr/src/gdcm
RUN git checkout release
RUN dnf install -y poppler-devel openjpeg-devel openssl-devel libuuid-devel json-c-devel CharLS-devel
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
  -DGDCM_USE_SYSTEM_SOCKETXX:BOOL=OFF \
  -DGDCM_USE_SYSTEM_UUID:BOOL=ON \
  -DGDCM_USE_SYSTEM_ZLIB:BOOL=ON \
  /usr/src/gdcm
RUN ninja-build
RUN ninja-build install

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
RUN ninja-build
RUN ninja-build install

WORKDIR /usr/src
RUN git clone https://github.com/statismo/statismo.git statismo
RUN mkdir -p statismo-build acvd-build
WORKDIR /usr/src/statismo-build
RUN dnf install -y eigen3-devel boost-devel
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
RUN ninja-build
RUN ninja-build install

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
RUN ninja-build
RUN ninja-build install

WORKDIR /usr/src
RUN rm -rf vtk* itk* statismo* acvd* gdcm*

# -DVTK_USE_64BIT_IDS:BOOL=ON
