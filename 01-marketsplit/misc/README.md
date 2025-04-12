# Desciption of Files

## gen_instances.sh

You can use this script to automatically generate a lot of instances ranging in all three parameters and saving the generated `.dat` files to appropriate folder.
Usage: 

```bash
./gen_instances.sh
```

## convert_dat2txt.awk

A small script to convert the `.dat` files to `.txt` files. 
This is needed for ZIMPL to read in the instance data.
Usage:

```bash
awk -f ./convert_csv2dat.awk <input_file_path> > <outpur_file_path>
```

## convert_txt2lp.sh

Uses ZIMPL to convert all `.txt` files in a given folder to `.lp` files with the formulation given. 
All of the `.lp` files will be put alongside the `.dat` files in the given directory. 
Usage: 

```bash
./convert_dat2lp.sh <directory>
```

___
## Old Instance generation


## gen_marketshare.cpp

Generates random markshare instances with a given seed and outputs them in a `.dat` format. 
Usage:

```bash
g++ gen_marketshare.cpp -o gen_marketshare
./gen_marketshare <m> <D> <seed>
```

## convert_dat2csv.py

Converts the `.dat` files to the agreed upon marketshare `.csv` format that is described [here](./../README.md).
Usage: 

```bash
python convert_dat2csv.py <input_file_path>
```

## sol2mdtable.py

Creates a Markdown document containing a table about solutions.

Usage: 
```bash
python sol2mdtable.py <outfile>
```
where `outfile` will be the resulting Markdown document.
With this, we created `solutions/README.md`.

