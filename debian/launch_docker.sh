#! /bin/bash
cwd=$(pwd)
echo $cwd

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

pushd $cwd
cd $dir
docker build -t "arnaudgelas/debian_test" .
docker run --rm -it arnaudgelas/debian_test
popd
