# compressor_decompressor_utility

![Open Source Love](https://badges.frapsoft.com/os/v3/open-source.svg?v=103) <img src="https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg"> <img src="https://img.shields.io/github/stars/naa7/compressor_decompressor_utility?style=social"> <img src="https://img.shields.io/github/repo-size/naa7/compressor_decompressor_utility"> [![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/naa7/compressor_decompressor_utility/LICENSE)

<img src="">
<img src=""></br> 

The idea of this project is to make a file compressor/decompressor which automates file (de)compression. Supported file extensions
are `tar`, `gz`, `bz2`, and `zip`. When compressing files, the user is given the option to select preferred compression method or
select a random compression method which is selected by the program itself. Also, the user is given the option of selecting how many
times they want the file to be compressed. For example, a user can select `tar` compression method and `50` times of file compression.
For decompressing files, the user is prompted to enter the name of the file to be decompressed and then process is automated. At the end
of program, user is given the option to change the name of the file. At the end, user is given a summary showing number and time of 
(de)compressions and (de)compressed file name.

## To run the program:

    $ cd && git clone https://github.com/naa7/compressor_decompressor_utility.git

    $ cd compressor_decompressor_utility/

    $ chmod +x compressor_decompressor_utility.sh && ./compressor_decompressor_utility.sh

## Optional

For easier use of the timer without the need to navigate to its directory and run the file,

copy `compressor_decompressor_utility.sh` file to `/usr/bin/` folder:

    $ mv compressor_decompressor_utility.sh compressor_decompressor_utility    

    $ sudo cp compressor_decompressor_utility /usr/bin/

Now, you can either open it from terminal

    $ compressor_decompressor_utility
