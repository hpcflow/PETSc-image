ARG GCC_V=13.2
FROM gcc:${GCC_V}

ARG PETSC_VERSION=3.19
RUN <<GetPETSc
    wget https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-${PETSC_VERSION}.tar.gz
    tar -xf petsc-${PETSC_VERSION}.tar.gz -C .
    rm petsc-${PETSC_VERSION}.tar.gz
    ln -s petsc-* petsc-${PETSC_VERSION}
GetPETSc
ENV PETSC_DIR=${PWD}/petsc-${PETSC_VERSION}
ENV PETSC_ARCH=gcc${GCC_V}
WORKDIR /petsc-${PETSC_VERSION}
RUN ./configure -j $(nproc) --with-fc=gfortran --with-cc=gcc --with-cxx=g++ --download-openmpi --download-fftw --download-hdf5 --download-hdf5-fortran-bindings=1 --download-zlib --with-mpi-f90module-visibility=1 --download-fblaslapack=1
RUN make all -j $(nproc)


# Multistage
RUN <<Clean&Keep
    rm -r gcc/externalpackages gcc/obj
Clean&Keep

FROM gcc:${GCC_V}
ARG PETSC_VERSION=3.19
COPY --from=0 /petsc-${PETSC_VERSION} /petsc-${PETSC_VERSION}
ENV PETSC_DIR=${PWD}/petsc-${PETSC_VERSION}
ENV PETSC_ARCH=gcc${GCC_V}
WORKDIR /petsc-${PETSC_VERSION}
RUN <<SysReq
    apt-get update
    apt-get install -y wget git software-properties-common make cmake pkg-config
SysReq

ENTRYPOINT [""]
CMD ["bash"]
