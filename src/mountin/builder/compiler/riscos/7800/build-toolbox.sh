#!/bin/bash
set -eu

cat >/opt/mountin/source/gccsdk-params <<'EOF'
export GCCSDK_INSTALL_CROSSBIN=/opt/gccsdk/cross/bin
export GCCSDK_INSTALL_ENV=/opt/gccsdk/env
EOF

cd /opt/mountin/source
export GCCSDK_ROOT=$PWD
. ./setup-gccsdk-params
mkdir -p buildstepsdir

make_args=(
    -j"$MOUNTIN_BUILD_JOBS"
    GCCSDK_INTERNAL_GETENV=
    GCC_LANGUAGES=c
    GCC_USE_SCM=no
    GCC_USE_PPL_CLOOG=no
    GCC_USE_LTO=no
    CROSS_ENABLE_SHARED=no
    GCC_CONFIG_ARGS='--enable-threads=posix --enable-sjlj-exceptions=no --enable-c99 --enable-cmath --disable-c-mbchar --disable-wchar_t --disable-libstdcxx-pch --disable-tls --enable-__cxa_atexit --enable-maintainer-mode --disable-werror --enable-interwork --disable-nls --disable-libquadmath --enable-checking=release --disable-multilib'
)

make "${make_args[@]}" src-automake-for-binutils-copied
install -m 755 /usr/share/misc/config.guess /usr/share/misc/config.sub \
    srcdir/automake-for-binutils/lib/
make "${make_args[@]}" src-libtool-for-binutils-copied
make "${make_args[@]}" \
    src-binutils-copied \
    src-gcc-copied \
    src-gmp-copied \
    src-mpc-copied \
    src-mpfr-copied \
    src-newlib-copied
while IFS= read -r script; do
    case "${script##*/}" in
        *.guess) source=/usr/share/misc/config.guess ;;
        *.sub) source=/usr/share/misc/config.sub ;;
    esac
    install -m 755 "$source" "$script"
done < <(find srcdir -type f \
    \( -name config.guess -o -name config.sub \
       -o -name configfsf.guess -o -name configfsf.sub \))
make "${make_args[@]}" cross-gcc-built
