# find duplicate files #

## description ##

Simple perl script that checksums all files in a starting directory, including the files in subdirectories. It then outputs all files with duplicate checksums.


## usage ##

./find_duplicate_files.pl <DIR_1> [... <DIR_N> ]

## note ##

1. naturally, checksumming takes very long. so be patient

2. an optimisation method would be to queue up all checksumming jobs and do them in one or more other processes. not implemented yet. still takes a lot of time.

3. the checksum is not cryptographically strong. it is not intended to be secure, the usage scennario is to find simple file duplications, not deliberate attempts to spoof same files.

## license ##

GPL3, see COPYING

## author ##

Alexander Köb <nerdkram@koeb.me>
