#!/bin/sh -e
#
#     Kay Hayen, mailto:kayhayen@gmx.de
#
#     Python test originally created or extracted from other peoples work. The
#     parts from me are in the public domain. It is at least Free Software
#     where it's copied from other people. In these cases, it will normally be
#     indicated.
#
#     If you submit Kay Hayen patches to this software in either form, you
#     automatically grant him a copyright assignment to the code, or in the
#     alternative a BSD license to the code, should your jurisdiction prevent
#     this. Obviously it won't affect code that comes to him indirectly or
#     code you don't submit to him.
#
#     This is to reserve my ability to re-license the code at any time, e.g.
#     the PSF. With this version of Nuitka, using it for Closed Source will
#     not be allowed.
#
#     Please leave the whole of this copyright notice intact.
#

echo "PASS 1: Compiling from compiler running from .py files."

BACKUP_PYTHONPATH=$PYTHONPATH

if [ "$1" != "quick" ]
then
    rm -f tests/reflected/*.so

    for file in `ls src/*.py`
    do
        echo "Compiling $file"

        Nuitka.py $file --output-dir tests/reflected/
    done

    mkdir -p tests/reflected/nodes
    rm -f tests/reflected/nodes/*.so

    for file in `ls src/nodes/*.py`
    do
        if [ $file != "src/nodes/__init__.py" ]
        then
            echo "Compiling $file"

            Nuitka.py $file --output-dir tests/reflected/nodes
        fi
    done

    cp src/nodes/__init__.py tests/reflected/nodes/

    mkdir -p tests/reflected/templates
    rm -f tests/reflected/templates/*.so

    for file in `ls src/templates/*.py`
    do
        if [ $file != "src/templates/__init__.py" ]
        then
            echo "Compiling $file"

            Nuitka.py $file --output-dir tests/reflected/templates
        fi
    done

    cp src/templates/__init__.py tests/reflected/templates/

    mkdir -p tests/reflected/optimizations
    rm -f tests/reflected/optimizations/*.so

    for file in `ls src/optimizations/*.py`
    do
        if [ $file != "src/optimizations/__init__.py" ]
        then
            echo "Compiling $file"

            Nuitka.py $file --output-dir tests/reflected/optimizations
        fi
    done

    cp src/optimizations/__init__.py tests/reflected/optimizations/

    Nuitka.py bin/Nuitka.py --output-dir tests/reflected/ --exe
else
    echo "Skipped."
fi

echo "PASS 2: Compiling from compiler running from .exe and many .so files."

for file in `ls src/*.py`
do
    echo "Compiling $file"

    TARGET="`basename $file .py`.build"
    rm -rf /tmp/$TARGET

    export PYTHONPATH=tests/reflected
    ./tests/reflected/Nuitka.exe $file --output-dir /tmp/
    diff -srq ./tests/reflected/$TARGET /tmp/$TARGET

    rm -rf /tmp/$TARGET
done

for file in `ls src/nodes/*.py`
do
    if [ $file != "src/nodes/__init__.py" ]
    then
        echo "Compiling $file"

        TARGET="`basename $file .py`.build"
        rm -rf /tmp/$TARGET

        export PYTHONPATH=tests/reflected
        ./tests/reflected/Nuitka.exe $file --output-dir /tmp/
        diff -srq ./tests/reflected/nodes/$TARGET /tmp/$TARGET

        rm -rf /tmp/$TARGET
    fi
done

for file in `ls src/templates/*.py`
do
    if [ $file != "src/templates/__init__.py" ]
    then
        echo "Compiling $file"

        TARGET="`basename $file .py`.build"
        rm -rf /tmp/$TARGET

        export PYTHONPATH=tests/reflected
        ./tests/reflected/Nuitka.exe $file --output-dir /tmp/
        diff -srq ./tests/reflected/templates/$TARGET /tmp/$TARGET

        rm -rf /tmp/$TARGET
    fi
done

for file in `ls src/optimizations/*.py`
do
    if [ $file != "src/optimizations/__init__.py" ]
    then
        echo "Compiling $file"

        TARGET="`basename $file .py`.build"
        rm -rf /tmp/$TARGET

        export PYTHONPATH=tests/reflected
        ./tests/reflected/Nuitka.exe $file --output-dir /tmp/
        diff -srq ./tests/reflected/optimizations/$TARGET /tmp/$TARGET

        rm -rf /tmp/$TARGET
    fi
done


echo "PASS 3: Compiling from compiler running from .py files to single .exe."

PYTHONPATH=$BACKUP_PYTHONPATH

Nuitka.py bin/Nuitka.py --output-dir /tmp/ --exe --deep

echo "PASS 4: Compiling the compiler running from single exe"

for file in `ls src/*.py`
do
    echo "Compiling $file"

    TARGET="`basename $file .py`.build"
    rm -rf /tmp/$TARGET

    /tmp/Nuitka.exe $file --output-dir /tmp/
    diff -srq ./tests/reflected/$TARGET /tmp/$TARGET

    rm -rf /tmp/$TARGET
done

for file in `ls src/nodes/*.py`
do
    if [ $file != "src/nodes/__init__.py" ]
    then
        echo "Compiling $file"

        TARGET="`basename $file .py`.build"
        rm -rf /tmp/$TARGET

        /tmp/Nuitka.exe $file --output-dir /tmp/
        diff -srq ./tests/reflected/nodes/$TARGET /tmp/$TARGET

        rm -rf /tmp/$TARGET
    fi
done

for file in `ls src/templates/*.py`
do
    if [ $file != "src/templates/__init__.py" ]
    then
        echo "Compiling $file"

        TARGET="`basename $file .py`.build"
        rm -rf /tmp/$TARGET

        /tmp/Nuitka.exe $file --output-dir /tmp/
        diff -srq ./tests/reflected/templates/$TARGET /tmp/$TARGET

        rm -rf /tmp/$TARGET
    fi
done
