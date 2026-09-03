FROM builder/compiler/aiwnios

ARG MOUNTIN_BUILD_JOBS
COPY source-drive.patch fix-dvd-image.patch aot-without-wrapper.patch raw-aot-starts-with-assembly.patch select-aot-signature.patch simplify-register-address.patch x86-address-of-register.patch fix-interrupt-keyword.patch preserve-function-flags.patch preserve-aot-static-data.patch translate-register-getters.patch current-rip.patch parse-asm-import.patch parse-asm-size-keywords.patch fix-asm-prefix-control-flow.patch emit-address-size-prefix.patch segment-aware-legacy-prefixes.patch honor-explicit-immediate-size.patch validate-asm-hash-entry.patch support-same-register-operands.patch resolve-asm-expression-imports.patch compile-asm-expressions-as-jit.patch relocate-unresolved-asm-symbols.patch resolve-aot-asm-labels.patch record-resolved-aot-abss.patch record-deferred-aot-abss.patch resolve-aot-asm-exports.patch resolve-aot-function-expressions.patch relocate-aot-asm-symbol-values.patch relocate-aot-function-references.patch relocate-aot-function-values.patch scope-aot-symbol-resolution.patch keep-extern-globals-as-imports.patch defer-aot-global-relocations.patch relocate-exported-globals.patch resolve-exact-asm-expression-imports.patch write-resolved-aot-asm-data.patch call-compiled-asm-expressions.patch widen-unresolved-branches.patch fix-test-immediate-opcode.patch fix-sign-extended-immediates.patch support-bit-scan-intrinsics.patch support-rdtsc-intrinsic.patch support-queue-init-intrinsic.patch support-invlpg-intrinsic.patch support-strlen-intrinsic.patch support-port-io-intrinsics.patch support-templeos-try-abi.patch preserve-aot-segment-registers.patch fix-ltr-opcode.patch emit-interrupt-epilogues.patch support-queue-mutation-intrinsics.patch zero-raw-aot-relocations.patch /tmp/

RUN set -eu; \
    mkdir -p /opt/aiwnios/source /opt/aiwnios/build; \
    tar --no-same-owner -xzf /host/build/sources/aiwnios-2026-02-02.tar.gz \
        -C /opt/aiwnios/source --strip-components=1; \
    patch -d /opt/aiwnios/source -p1 < /tmp/source-drive.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/fix-dvd-image.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/aot-without-wrapper.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/raw-aot-starts-with-assembly.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/select-aot-signature.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/simplify-register-address.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/x86-address-of-register.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/fix-interrupt-keyword.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/preserve-function-flags.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/preserve-aot-static-data.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/translate-register-getters.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/current-rip.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/parse-asm-import.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/parse-asm-size-keywords.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/fix-asm-prefix-control-flow.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/emit-address-size-prefix.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/segment-aware-legacy-prefixes.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/honor-explicit-immediate-size.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/validate-asm-hash-entry.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/support-same-register-operands.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/resolve-asm-expression-imports.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/compile-asm-expressions-as-jit.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/relocate-unresolved-asm-symbols.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/resolve-aot-asm-labels.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/record-resolved-aot-abss.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/record-deferred-aot-abss.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/resolve-aot-asm-exports.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/resolve-aot-function-expressions.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/relocate-aot-asm-symbol-values.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/scope-aot-symbol-resolution.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/keep-extern-globals-as-imports.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/defer-aot-global-relocations.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/relocate-aot-function-references.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/relocate-aot-function-values.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/relocate-exported-globals.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/resolve-exact-asm-expression-imports.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/write-resolved-aot-asm-data.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/call-compiled-asm-expressions.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/widen-unresolved-branches.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/fix-test-immediate-opcode.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/fix-sign-extended-immediates.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/support-bit-scan-intrinsics.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/support-rdtsc-intrinsic.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/support-queue-init-intrinsic.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/support-invlpg-intrinsic.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/support-strlen-intrinsic.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/support-port-io-intrinsics.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/support-templeos-try-abi.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/preserve-aot-segment-registers.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/fix-ltr-opcode.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/emit-interrupt-epilogues.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/support-queue-mutation-intrinsics.patch; \
    patch -d /opt/aiwnios/source -p1 < /tmp/zero-raw-aot-relocations.patch; \
    cmake -S /opt/aiwnios/source -B /opt/aiwnios/build \
        -DCMAKE_BUILD_TYPE=Debug; \
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy \
        cmake --build /opt/aiwnios/build -j"${MOUNTIN_BUILD_JOBS}" \
            --target HCRT2.BIN; \
    test -s /opt/aiwnios/source/HCRT2.BIN; \
    ln -s /opt/aiwnios/source/aiwnios /usr/local/bin/aiwnios

WORKDIR /work
