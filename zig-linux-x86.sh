#!/bin/bash 

mkdir -p $HOME/.local/bin
export PATH="/usr/local/zig:$HOME/.local/bin:$PATH"

cat <<EOF > ~/.local/bin/clang
zig cc -target x86-linux-musl "\$@"
EOF

cat <<EOF > ~/.local/bin/clang++
zig c++ -target x86-linux-musl "\$@"
EOF

cat <<EOF > ~/.local/bin/ar
zig ar "\$@"
EOF

cat <<EOF > ~/.local/bin/ranlib
zig ranlib "\$@"
EOF

cat <<EOF > ~/.local/bin/rc
zig rc "\$@"
EOF

cat <<EOF > ~/.local/bin/lib
zig lib "\$@"
EOF

cat <<EOF > ~/.local/bin/dlltool
zig dlltool "\$@"
EOF

cat <<EOF > ~/.local/bin/objcopy
zig objcopy "\$@"
EOF

chmod +x ~/.local/bin/*


