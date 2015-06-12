#! /bin/bash
cwd=$(pwd)
echo $cwd

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

pushd $cwd
cd $dir
docker build -t "arnaudgelas/fedora_test" .
docker run --rm -it arnaudgelas/fedora_test /bin/bash
popd
