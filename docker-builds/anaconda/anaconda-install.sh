#!/bin/bash
# Copyright (c) 2012-2013 Continuum Analytics, Inc.
# All rights reserved.
#
# NAME:  Anaconda
# VER:   1.5.0
# PLAT:  linux-64
# DESCR: 1.4.0-888-g5c37ff3
# BYTES: 321578266
# LINES: 371
# MD5:   ef6521e88b7eeabd6b7bae1a41ad728e

unset LD_LIBRARY_PATH

THIS_DIR=$(cd $(dirname $0); pwd)
THIS_FILE=$(basename $0)
THIS_PATH="$THIS_DIR/$THIS_FILE"
PREFIX=$HOME/anaconda
BATCH=0

# TODO check if exists and is the right size etc and only download if needed
curl -O http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/Anaconda-1.5.0-Linux-x86_64.sh

mkdir -p $PREFIX
if (( $? )); then
    echo "ERROR: Could not create directory: $PREFIX" >&2
    exit 1
fi


PREFIX=$(cd $PREFIX; pwd)
export PREFIX

cd $PREFIX

tail -n +371 "$THIS_DIR/Anaconda-1.5.0-Linux-x86_64.sh" | tar xf -

install_dist()
{
    echo "installing: $1 ..."
    DIST=$PREFIX/pkgs/$1
    mkdir -p $DIST
    tar xjf ${DIST}.tar.bz2 -C $DIST || exit 1
    rm -f ${DIST}.tar.bz2
}

install_dist python-2.7.4-0
install_dist _license-1.1-py27_0
install_dist astropy-0.2.1-np17py27_0
install_dist atom-0.2.3-py27_0
install_dist biopython-1.61-np17py27_0
install_dist bitarray-0.8.1-py27_0
install_dist boto-2.9.2-py27_0
install_dist cairo-1.12.2-1
install_dist casuarius-1.1-py27_0
install_dist conda-1.5.2-py27_0
install_dist cubes-0.10.2-py27_1
install_dist curl-7.30.0-0
install_dist cython-0.19-py27_0
install_dist dateutil-2.1-py27_1
install_dist disco-0.4.4-py27_0
install_dist distribute-0.6.36-py27_1
install_dist docutils-0.10-py27_0
install_dist dynd-python-0.3.0-np17py27_0
install_dist enaml-0.7.6-py27_0
install_dist erlang-R15B01-0
install_dist flask-0.9-py27_0
install_dist freetype-2.4.10-0
install_dist gevent-0.13.8-py27_0
install_dist gevent-websocket-0.3.6-py27_2
install_dist gevent_zeromq-0.2.5-py27_2
install_dist greenlet-0.4.0-py27_0
install_dist grin-1.2.1-py27_1
install_dist h5py-2.1.1-np17py27_0
install_dist hdf5-1.8.9-0
install_dist imaging-1.1.7-py27_2
install_dist ipython-0.13.2-py27_0
install_dist jinja2-2.6-py27_0
install_dist jpeg-8d-0
install_dist libdynd-0.3.0-0
install_dist libevent-2.0.20-0
install_dist libnetcdf-4.2.1.1-1
install_dist libpng-1.5.13-1
install_dist libxml2-2.9.0-0
install_dist libxslt-1.1.28-0
install_dist llvm-3.2-0
install_dist llvmpy-0.11.2-py27_0
install_dist lxml-3.2.0-py27_0
install_dist matplotlib-1.2.1-np17py27_1
install_dist mdp-3.3-np17py27_0
install_dist meta-0.4.2.dev-py27_0
install_dist mpi4py-1.3-py27_0
install_dist mpich2-1.4.1p1-0
install_dist netcdf4-1.0.4-np17py27_0
install_dist networkx-1.7-py27_0
install_dist nltk-2.0.4-np17py27_0
install_dist nose-1.3.0-py27_0
install_dist numba-0.8.1-np17py27_0
install_dist numexpr-2.0.1-np17py27_3
install_dist numpy-1.7.1-py27_0
install_dist opencv-2.4.2-np17py27_1
install_dist openssl-1.0.1c-0
install_dist pandas-0.11.0-np17py27_1
install_dist pip-1.3.1-py27_1
install_dist pixman-0.26.2-0
install_dist ply-3.4-py27_0
install_dist psutil-0.7.1-py27_0
install_dist py-1.4.12-py27_0
install_dist py2cairo-1.10.0-py27_1
install_dist pycosat-0.6.0-py27_0
install_dist pycparser-2.9.1-py27_0
install_dist pycrypto-2.6-py27_0
install_dist pycurl-7.19.0-py27_2
install_dist pyflakes-0.7.2-py27_0
install_dist pygments-1.6-py27_0
install_dist pyparsing-1.5.6-py27_0
install_dist pysal-1.5.0-np17py27_1
install_dist pysam-0.6-py27_0
install_dist pyside-1.1.2-py27_0
install_dist pytables-2.4.0-np17py27_0
install_dist pytest-2.3.4-py27_1
install_dist pytz-2013b-py27_0
install_dist pyyaml-3.10-py27_0
install_dist pyzmq-2.2.0.1-py27_1
install_dist qt-4.7.4-0
install_dist readline-6.2-0
install_dist redis-2.6.9-0
install_dist redis-py-2.7.2-py27_0
install_dist requests-1.2.0-py27_0
install_dist rope-0.9.4-py27_0
install_dist scikit-image-0.8.2-np17py27_1
install_dist scikit-learn-0.13.1-np17py27_0
install_dist scipy-0.12.0-np17py27_0
install_dist shiboken-1.1.2-py27_0
install_dist six-1.3.0-py27_0
install_dist sphinx-1.1.3-py27_3
install_dist spyder-2.2.0-py27_0
install_dist sqlalchemy-0.8.1-py27_0
install_dist sqlite-3.7.13-0
install_dist statsmodels-0.4.3-np17py27_1
install_dist sympy-0.7.2-py27_0
install_dist system-5.8-1
install_dist theano-0.5.0-np17py27_1
install_dist tk-8.5.13-0
install_dist tornado-3.0.1-py27_0
install_dist util-linux-2.21-0
install_dist werkzeug-0.8.3-py27_0
install_dist xlrd-0.9.2-py27_0
install_dist xlwt-0.7.5-py27_0
install_dist yaml-0.1.4-0
install_dist zeromq-2.2.0-1
install_dist zlib-1.2.7-0
install_dist anaconda-1.5.0-np17py27_0

mkdir $PREFIX/envs
mkdir $HOME/.continuum 2>/dev/null

PYTHON="$PREFIX/pkgs/python-2.7.4-0/bin/python -E"
$PYTHON -V
if (( $? )); then
    echo "ERROR:
cannot execute native linux-64 binary, output from 'uname -a' is:" >&2
    uname -a
    exit 1
fi

echo "creating default environment..."
CONDA_INSTALL="$PREFIX/pkgs/conda-1.5.2-py27_0/lib/python2.7/site-packages/conda/install.py"
$PYTHON $CONDA_INSTALL --prefix=$PREFIX --pkgs-dir=$PREFIX/pkgs --link-all || exit 1
echo "installation finished."

if [[ $PYTHONPATH != "" ]]; then
    echo "WARNING:
    You current have a PYTHONPATH environment variable set. This may cause
    unexpected behavior when running the Python interpreter in Anaconda.
    For best results, please verify that your PYTHONPATH only points to
    directories of packages that are compatible with the Python interpreter
    in Anaconda: $PREFIX"
fi

echo "
# added by Anaconda 1.5.0 installer
export PATH=\"$PREFIX/bin:\$PATH\"" >>$BASH_RC

rm "$THIS_DIR/Anaconda-1.5.0-Linux-x86_64.sh"

exit 0
