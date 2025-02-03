#!/bin/bash

ncdump tohoku_slab.e > tohoku_slab.txt
./exodus2semgeotech tohoku_slab.txt
