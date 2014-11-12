# openstack-beginners-guide
=========================

## OpenStack Beginner's Guide for Ubuntu 14.04, Trusty Tahr
=============================================================

    + OpenStack version: IceHouse
    + Ubuntu Version: Ubuntu 14.04 LTS (Trusty Tahr)
    + License: Creative Commons Attribution Sharealike 4.0 International


- This is a tutorial style Beginner's guide for OpenStack IceHouse on Ubuntu 14.04. 
- The aim is to help the reader in setting up a minimal installation of OpenStack over two machines

- The beginner's guide has been written using DocBook 5.0

- Each chapter has a dedicated DocBook source file.

Layout of the source:
---------------------
    openstackbook
            |
            |_ images - contains images used in this guide
            |
            |_ *.xml - DocBook source for the chapter
            |
            |_ README - this file

## Building the PDF from Docbook source

- Using dblatex command
- Using a2x 
- Building individual files and using PDF-toolkit (pdftk) to join them into a single PDF file.

## Known issues

- When building PDF files using DBLATEX, single quotes (apostrophes) get converted to backquotes automatically. Be careful when you copy/paste commands. 

## Bugs and Issues:

Kindly create an issue on GitHub for any bugs. 
