#!/bin/bash 

mkdir -p $HOME/.local/bin
export PATH="$HOME/.local/bin:$PATH"
export LD=ld.lld
export CC=clang
export CXX=clang++
export ASM=${CC}

cat <<EOF > ~/.local/bin/clang
#!/bin/sh

exec zig cc -target x86_64-linux-musl \$@
EOF

cat <<EOF > ~/.local/bin/clang-pie
#!/bin/sh

exec zig cc -target x86_64-linux-musl \$@ -fPIE -fpie -fPIC
EOF

cat <<EOF > ~/.local/bin/clang-no-pie
#!/bin/sh

exec zig cc -target x86_64-linux-musl \$@ -fno-PIE -fno-pie
EOF

cat <<EOF > ~/.local/bin/clang++
#!/bin/sh

exec zig c++ -target x86_64-linux-musl \$@
EOF

cat <<EOF > ~/.local/bin/clang++-pie
#!/bin/sh

exec zig c++ -target x86_64-linux-musl \$@ -fPIE -fpie -fPIC
EOF

cat <<EOF > ~/.local/bin/clang++-no-pie
#!/bin/sh

exec zig c++ -target x86_64-linux-musl \$@ -fno-PIE -fno-pie
EOF

cat <<EOF > ~/.local/bin/gnuc
#!/bin/sh

exec zig cc -target x86_64-linux-gnu \$@
EOF

cat <<EOF > ~/.local/bin/gnuc-pie
#!/bin/sh

exec zig cc -target x86_64-linux-gnu \$@ -fPIE -fpie -fPIC
EOF

cat <<EOF > ~/.local/bin/gnuc-no-pie
#!/bin/sh

exec zig cc -target x86_64-linux-gnu \$@ -fno-PIE -fno-pie
EOF

cat <<EOF > ~/.local/bin/gnuc++
#!/bin/sh

exec zig c++ -target x86_64-linux-gnu \$@
EOF

cat <<EOF > ~/.local/bin/gnuc++-pie
#!/bin/sh

exec zig c++ -target x86_64-linux-gnu \$@ -fPIE -fpie -fPIC
EOF

cat <<EOF > ~/.local/bin/gnuc++-no-pie
#!/bin/sh

exec zig c++ -target x86_64-linux-gnu \$@ -fno-pie
EOF

chmod +x ~/.local/bin/clang*
chmod +x ~/.local/bin/gnuc*


