# Use uma imagem base do Ubuntu
FROM ubuntu:20.04

# Defina o mantenedor da imagem
LABEL maintainer="seu_email@example.com"

# Defina variáveis de ambiente para evitar interações durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Atualize o sistema e instale as dependências necessárias
RUN apt-get update && apt-get install -y \
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
    libncurses-dev:i386 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instale o repo para gerenciar o código-fonte do Android
RUN mkdir -p /usr/local/bin && \
    curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo && \
    chmod a+x /usr/local/bin/repo

# Defina o diretório de trabalho
WORKDIR /android

# Clone o código-fonte do Android-x86
RUN repo init -u https://android.googlesource.com/platform/manifest.git -b master --depth=1 && \
    repo sync -c -j4 --no-clone-bundle

# Remova aplicativos padrão, mantendo apenas o navegador
RUN echo "PRODUCT_PACKAGES := Browser" > device/generic/common/mini.mk && \
    echo "PRODUCT_NAME := aosp_mini" >> device/generic/common/mini.mk && \
    echo "PRODUCT_DEVICE := generic_x86" >> device/generic/common/mini.mk && \
    echo "PRODUCT_BRAND := Android" >> device/generic/common/mini.mk && \
    echo "PRODUCT_MODEL := Android Browser Edition" >> device/generic/common/mini.mk && \
    echo "PRODUCT_MANUFACTURER := Google" >> device/generic/common/mini.mk

# Adicione APKs personalizados ao sistema
COPY assets/*.apk device/generic/common/preinstall/

# Configure a animação de inicialização
COPY assets/bootanimation.zip device/generic/common/media/

# Defina o comando de construção
CMD ["bash", "-c", "source build/envsetup.sh && lunch aosp_mini-userdebug && make iso_img -j$(nproc)"]
