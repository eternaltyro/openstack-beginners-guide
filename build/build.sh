#!/bin/bash
: '
Name: build.sh
Version: 
Run: bash -c build.sh
Depends: dblatex, pdftk, pdflatex
Author: Murthy Raju M.
License: 
Description: 
'


# Build the main matter for the book
function build_main()
{
    echo "Building the main matter from docbook"
    cd trusty
    dblatex -P latex.class.book=book -P doc.layout="toc mainmatter" -s ../style/mystyle.sty Openstackbook.xml
    #dblatex -P latex.class.book=book -P doc.layout="toc mainmatter" Openstackbook.xml
    
    echo "Moving main matter.pdf to build directory"
    cd ..
    mkdir build
    mv trusty/Openstackbook.pdf build/

    build_front
}

# Build the front matter for the book
function build_front()
{
    echo "Building the front matter from tex source"
    cd tex
    pdflatex openstackbookfm.tex
    
    echo "Moving front matter pdf to build directory"
    mv openstackbookfm.pdf ../build
    
    # Cleanup auxillary files created during build
    echo "Cleaning up the directory"
    rm *aux *out *idx *.log

    build_merge
}

# Merge the front matter and main matter to create the final pdf
function build_merge()
{
    cd ../build
    echo "Merging front matter with main matter and creating the book as pdf"
    pdftk openstackbookfm.pdf Openstackbook.pdf cat output OpenStackBookV4-2.pdf
}

# Checkout the OpenStackBook V3.0 source
function checkout()
{
    echo "Checking out the bazaar branch of OpenStackBook for Essex"
    if [ -d "essex" ]; then
        echo "You already have a copy of OpenStackBook for Essex."
        echo "**********************************INFO************************************"
        echo "If you are checking out a new copy your local copy will be renamed from"
        echo "essex to essex_YYYYMMDDhhmm"
        echo "**********************************INFO************************************"
        echo -n "Do you want to checkout anyway?(y/n)"
        read option
        if [ "${option}" == "y" ]; then
            
            # Clean up any existing build directory
            suffix=`date +%Y%m%d%H%M`
            rm -rf build
            mv essex essex_${suffix}

            bzr branch lp:~openstackbook/openstackbook/essex
        elif [ "${option}" == "n" ]; then
            echo -n "Do you want to build the pdf?(y/n)"
            read option
            if [ "${option}" == "y" ]; then
                build_main
            else
                cd essex
                echo "***************************************************************"
                bzr status
                echo "***************************************************************"
                echo "The above files have to be committed"
                exit 0
            fi
        else
            echo "Incorrect option specified."
            exit 0
        fi
    else
        bzr branch lp:~openstackbook/openstackbook/essex
        build_main
    fi
}

#checkout
build_main
