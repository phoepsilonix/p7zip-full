#!/bin/bash 

mkdir -p $HOME/.local/bin
export PATH="/usr/local/zig:$HOME/.local/bin:$PATH"

cat <<EOF > ~/.local/bin/clang
zig cc -target x86_64-linux-musl "\$@"
EOF

cat <<EOF > ~/.local/bin/clang++
zig c++ -target x86_64-linux-musl "\$@"
EOF

cat <<EOF > ~/.local/bin/ar
zig ar -target x86_64-linux-musl "\$@"
EOF

cat <<EOF > ~/.local/bin/ranlib
zig ranlib -target x86_64-linux-musl "\$@"
EOF

cat <<EOF > ~/.local/bin/rc
zig rc -target x86_64-linux-musl "\$@"
EOF

cat <<EOF > ~/.local/bin/lib
zig lib -target x86_64-linux-musl "\$@"
EOF

cat <<EOF > ~/.local/bin/dlltool
zig dlltool -target x86_64-linux-musl "\$@"
EOF

cat <<EOF > ~/.local/bin/objcopy
zig objcopy -target x86_64-linux-musl "\$@"
EOF

chmod +x ~/.local/bin/*


