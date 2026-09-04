FROM builder/compiler/aiwnios

ARG MOUNTIN_BUILD_JOBS
COPY aot-output/ /tmp/aot-output/
COPY aot-assembly-expressions/ /tmp/aot-assembly-expressions/
COPY aot-symbol-resolution/ /tmp/aot-symbol-resolution/
COPY aot-relocations/ /tmp/aot-relocations/
COPY templeos-signature/ /tmp/templeos-signature/
COPY function-flags/ /tmp/function-flags/
COPY aot-static-data/ /tmp/aot-static-data/
COPY current-pc/ /tmp/current-pc/
COPY register-expressions/ /tmp/register-expressions/
COPY interrupt-functions/ /tmp/interrupt-functions/
COPY x86-intrinsics/ /tmp/x86-intrinsics/
COPY runtime-intrinsics/ /tmp/runtime-intrinsics/
COPY exception-abi/ /tmp/exception-abi/
COPY source-environment/ /tmp/source-environment/
COPY iso-generation/ /tmp/iso-generation/
COPY runtime-compatibility/ /tmp/runtime-compatibility/
COPY x86-assembler/ /tmp/x86-assembler/

RUN set -eu; \
    mkdir -p /opt/aiwnios/source /opt/aiwnios/build; \
    tar --no-same-owner -xzf /host/build/sources/aiwnios-2026-02-02.tar.gz \
        -C /opt/aiwnios/source --strip-components=1; \
    patch -d /opt/aiwnios/source -p1 < /tmp/interrupt-functions/default-iret-to-64-bit.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/x86-assembler/fix-x86-opcode-table.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/source-environment/source-drive.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/iso-generation/fix-dvd-image.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-output/aot-without-wrapper.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-output/raw-aot-starts-with-assembly.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-output/preserve-raw-aot-alignment.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/templeos-signature/select-aot-signature.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/register-expressions/simplify-register-address.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/register-expressions/lower-register-address.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/interrupt-functions/fix-interrupt-keyword.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/function-flags/preserve-function-flags.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-static-data/preserve-aot-static-data.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-static-data/clear-aot-static-reference.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/register-expressions/translate-x86-register-getters.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/current-pc/current-pc.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/x86-assembler/parse-asm-operand-prefixes.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/x86-assembler/encode-segment-prefixes.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/x86-assembler/honor-explicit-immediate-size.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/x86-assembler/support-same-register-operands.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-assembly-expressions/parse-asm-import.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-assembly-expressions/resolve-asm-expression-imports.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-assembly-expressions/compile-asm-expressions-as-jit.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-relocations/relocate-unresolved-asm-symbols.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-symbol-resolution/resolve-aot-asm-labels.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-relocations/record-resolved-aot-abss.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-relocations/record-deferred-aot-abss.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-symbol-resolution/resolve-aot-asm-exports.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-symbol-resolution/resolve-aot-function-expressions.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-relocations/relocate-aot-asm-symbol-values.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-symbol-resolution/scope-aot-symbol-resolution.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-relocations/keep-extern-globals-as-imports.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-relocations/defer-aot-global-relocations.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-relocations/relocate-aot-function-references.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-relocations/relocate-aot-function-values.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-relocations/relocate-exported-globals.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-assembly-expressions/resolve-exact-asm-expression-imports.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-relocations/write-resolved-aot-asm-data.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-assembly-expressions/call-compiled-asm-expressions.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/x86-assembler/widen-unresolved-branches.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/x86-assembler/fix-sign-extended-immediates.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/x86-intrinsics/support-bit-scan-intrinsics.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/x86-intrinsics/support-rdtsc-intrinsic.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/runtime-intrinsics/support-queue-init-intrinsic.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/x86-intrinsics/support-invlpg-intrinsic.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/runtime-intrinsics/support-strlen-intrinsic.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/x86-intrinsics/support-port-io-intrinsics.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/exception-abi/support-templeos-try-abi.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/interrupt-functions/preserve-native-segments.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/interrupt-functions/compile-interrupt-functions.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/runtime-intrinsics/support-queue-mutation-intrinsics.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-relocations/zero-raw-aot-relocations.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/x86-intrinsics/support-rflags-intrinsic.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/x86-intrinsics/support-register-setters.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/runtime-compatibility/enable-sse-runtime.patch; \
    cmake -S /opt/aiwnios/source -B /opt/aiwnios/build \
        -DCMAKE_BUILD_TYPE=Debug; \
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy \
        cmake --build /opt/aiwnios/build -j"${MOUNTIN_BUILD_JOBS}" \
            --target HCRT2.BIN; \
    test -s /opt/aiwnios/source/HCRT2.BIN; \
    ln -s /opt/aiwnios/source/aiwnios /usr/local/bin/aiwnios

WORKDIR /work
