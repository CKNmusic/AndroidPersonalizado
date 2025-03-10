# Use uma imagem base do Ubuntu
FROM ubuntu:latest

# Defina o diretório de trabalho
WORKDIR /workspace

# Instale as dependências necessárias
RUN apt-get update && \
    apt-get install -y \
    openjdk-11-jdk \
    git \
    gnupg \
    flex \
    bison \
    gperf \
    build-essential \
    zip \
    curl \
    zlib1g-dev \
    gcc-multilib \
    g++-multilib \
    libc6-dev-i386 \
    lib32z-dev \
    libgl1-mesa-dev \
    libxml2-utils \
    xsltproc \
    unzip \
    libncurses5-dev \
    libncurses-dev:i386 && \
    apt-get clean

# Configure o repositório 'repo' e clone o código-fonte do Android-x86
RUN mkdir -p ~/bin && \
    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo && \
    chmod a+x ~/bin/repo && \
    export PATH=$HOME/bin:$PATH && \
    mkdir ~/android-x86 && \
    cd ~/android-x86 && \
    repo init -u https://android.googlesource.com/platform/manifest.git -b master --depth=1 && \
    repo sync -c -j4 --no-clone-bundle

# Remova aplicativos padrão, mantendo apenas o navegador
RUN cd ~/android-x86 && \
    echo "PRODUCT_PACKAGES := Browser" > device/generic/common/mini.mk && \
    echo "PRODUCT_NAME := aosp_mini" >> device/generic/common/mini.mk && \
    echo "PRODUCT_DEVICE := generic_x86" >> device/generic/common/mini.mk && \
    echo "PRODUCT_BRAND := Android" >> device/generic/common/mini.mk && \
    echo "PRODUCT_MODEL := Android Browser Edition" >> device/generic/common/mini.mk && \
    echo "PRODUCT_MANUFACTURER := Google" >> device/generic/common/mini.mk

# Adicione APKs ao sistema
COPY assets/*.apk /workspace/android-x86/device/generic/common/preinstall/

# Configure a animação de inicialização
COPY assets/bootanimation.zip /workspace/android-x86/device/generic/common/media/

# Configure a build minimalista
RUN cd ~/android-x86 && \
    source build/envsetup.sh && \
    lunch aosp_mini-userdebug && \
    make iso_img -j$(nproc)

# Defina o comando de entrada
CMD ["bash"]
