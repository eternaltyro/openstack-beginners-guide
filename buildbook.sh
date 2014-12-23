#!/bin/bash
# Copyrights (c) Murthyraju. Free software
# Changes by ~eternaltyro. Experimental. Use with caution.

# -- Requisites -- #
# pdflatex - apt-get install texlive-latex-base
# dblatex - apt-get install dblatex
# pdftk - apt-get install pdftk
# -- Requisites -- #

# Build the main matter for the book
function build_main()
{
    echo "Building the main matter from docbook"
    pushd icehouse
    dblatex -P latex.class.book=book -P doc.layout="toc mainmatter" -s ../style/mystyle.sty Openstackbook.xml
    #dblatex -P latex.class.book=book -P doc.layout="toc mainmatter" Openstackbook.xml
    
    echo "Moving main matter.pdf to build directory"
    popd
    mkdir build
    mv icehouse/Openstackbook.pdf build/

    build_front
}

# Build the front matter for the book
function build_front()
{
    echo "Building the front matter from tex source"
    pushd tex/
    pdflatex openstackbookfm.tex
    
    echo "Moving front matter pdf to build directory"
    mv openstackbookfm.pdf ../build
    
    # Cleanup auxillary files created during build
    echo "Cleaning up the directory"
    rm *aux *out *idx *.log
    popd 

    build_merge
}

# Merge the front matter and main matter to create the final pdf
function build_merge()
{
    pushd build/
    echo "Merging front matter with main matter and creating the book as pdf"
    pdftk openstackbookfm.pdf Openstackbook.pdf cat output OpenStackBookV4-2.pdf
}

# Checkout the OpenStackBook V3.0 source
function checkout()
{
    echo "Checking out the git branch of OpenStackBook for Icehouse"
    if [ -d "icehouse" ]; then
        echo "You already have a copy of OpenStackBook for Icehouse."
        echo "**********************************INFO************************************"
        echo "If you are checking out a new copy your local copy will be renamed from"
        echo "icehouse to icehouse_YYYYMMDDhhmm"
        echo "**********************************INFO************************************"
        echo -n "Do you want to checkout anyway?(y/n)"
        read option
        if [ "${option}" == "y" ]; then
            
            # Clean up any existing build directory
            suffix=`date +%Y%m%d%H%M`
            rm -rf build
            mv icehouse icehouse_${suffix}

            git clone https://github.com/eternaltyro/openstack-beginners-guide.git
        elif [ "${option}" == "n" ]; then
            echo -n "Do you want to build the pdf?(y/n)"
            read option
            if [ "${option}" == "y" ]; then
                build_main
            else
                cd icehouse
                echo "***************************************************************"
                git status
                echo "***************************************************************"
                echo "The above files have to be committed"
                exit 0
            fi
        else
            echo "Incorrect option specified."
            exit 0
        fi
    else
        git clone https://github.com/eternaltyro/openstack-beginners-guide.git
        build_main
    fi
}

# Uncomment the below line if you want to pull the code the book before building the PDF
#checkout
build_main
