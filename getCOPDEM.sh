#!/bin/bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    ${getCOPDEM.sh} [-hv] [-o[file]] [-rootDir <path>] [-dataDir <path>] [-latStart <lat>] [-latEnd <lat>] [-lonStart <lon>] [-lonEnd <lon>]
#%
#% DESCRIPTION
#%    This script downloads the Copernicus Digital 
#%    Elevation Model (COP-DEM-GLO-90) data tiles using aria2
#%    and curl.
#%
#% OPTIONS
#%    -o [file], --output=[file]    Set log file to record the 
#%                                  downloaded list of tiles 
#%                                  (default=/dev/null)
#%    -rootDir <path>               Path to the working directory            
#%    -dataDir <path>               Path to the directory where to save the downloaded data                  
#%    -latStart <lat>               Southern boundary in decimal degrees (°S)
#%    -latEnd <lat>                 Northern boundary in decimal degrees (°N)
#%    -lonStart <lon>               Western boundary in decimal degrees (°W)
#%    -lonEnd <lon>                 Eastern boundary in decimal degrees (°E)
#%    -v, --version                  Print script information
#%
#% EXAMPLES
#%    ${getCOPDEM.sh} -o DEFAULT -rootDir /home/robel/WSC/ -dataDir /home/robel/WSC/data/Elevation/COPDEM-GLO90/Tiles/ -latStart -46 -latEnd 38 -lonStart -25 -lonEnd 64
#%
#================================================================
#- IMPLEMENTATION
#-    version         ${getCOPDEM.sh} 0.1.0
#-    author          Robel Takele
#-    copyright       Copyright (c) 2024 Robel Takele Miteku (https://github.com/RobelTakele)
#-    license         GNU General Public License
#-
#================================================================
#  HISTORY
#     2024/09/29 : RobelTakele : Script creation
# 
#================================================================
#  DEBUG OPTION
#    set -n  # Uncomment to check your syntax, without execution.
#    set -x  # Uncomment to debug this shell script
#
#================================================================
# END_OF_HEADER
#================================================================

filePath() {
    local path="$1"
    shift
    for element in "$@"; do
        # Remove trailing slash from the base path
        path="${path%/}"
        # Remove leading slash from the next element
        element="${element#/}"
        # Concatenate with a single slash in between
        path="$path/$element"
    done
    echo "$path"
}

#################################################################
#################################################################
## ***** strict error checking:

set -euo pipefail

## ***** Default values:
rootDir="/home/robel/WSC/"
dataDir="$(filePath "${rootDir}" "/data/Elevation/COPDEM-GLO90/Tiles/")"
latStart=-20  # Southern boundary (°S)
latEnd=30     # Northern boundary (°N)
lonStart=20  # Western boundary (°W)
lonEnd=40     # Eastern boundary (°E)
logFile="/dev/null"

#################################################################
#################################################################
## ***** Parse input arguments:
while [ $# -gt 0 ]; do
    case "$1" in
        -rootDir)
            rootDir="$2"
            shift 2
            ;;
        -dataDir)
            dataDir="$2"
            shift 2
            ;;
        -latStart)
            latStart="$2"
            shift 2
            ;;
        -latEnd)
            latEnd="$2"
            shift 2
            ;;
        -lonStart)
            lonStart="$2"
            shift 2
            ;;
        -lonEnd)
            lonEnd="$2"
            shift 2
            ;;
        -o)
            logFile="$2"
            shift 2
            ;;
        -v|--version)
            echo "${getCOPDEM.sh} 0.1.1"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

## ***** Validate input parameters:
if [ -z "$rootDir" ] || [ -z "$dataDir" ]; then
    echo "Error: rootDir and dataDir must be provided." >&2
    exit 1
fi

## ***** Log setup:
exec > >(tee -i "$logFile") 2>&1

## ***** Create the data directory if it does not exist:
mkdir -p "$(filePath "${dataDir}")"

## ***** Log the starting time:
echo "Starting COP-DEM tile download at $(date)"

## ***** URL base for downloading tiles:
urlBase="https://prism-dem-open.copernicus.eu/pd-desk-open-access/prismDownload/COP-DEM_GLO-90-DGED__2023_1/"

## ***** Function to generate the list of tile names:
makeTileList() {
    local latStart=$1
    local latEnd=$2
    local lonStart=$3
    local lonEnd=$4
    local urlBase=$5
    local tileList=()

    for (( lat=latStart; lat<=latEnd; lat++ )); do
        for (( lon=lonStart; lon<=lonEnd; lon++ )); do
   
            if [ $lat -ge 0 ]; then
                latStr=$(printf "N%02d" $lat)
            else
                latStr=$(printf "S%02d" $(( -lat )))
            fi

            if [ $lon -ge 0 ]; then
                lonStr=$(printf "E%03d" $lon)
            else
                lonStr=$(printf "W%03d" $(( -lon )))
            fi

            tileName=$(printf "Copernicus_DSM_30_%s_00_%s_00.tar" "$latStr" "$lonStr")
            tileURL="${urlBase}${tileName}"
            tileList+=("$tileURL")
        done
    done

    echo "${tileList[@]}"
}

## ***** Generate and save the list of tiles:
tileList=$(makeTileList ${latStart} ${latEnd} ${lonStart} ${lonEnd} ${urlBase})
tileListFile="$(filePath "${dataDir}")/Africa_Copernicus_GLO90_Tile_List.txt"
echo "${tileList}" | tr ' ' '\n' > "${tileListFile}"

## ***** Parallel download function:
downloadTile() {
    tileURL="$1"
    dataDir="$2"
    
    echo "***** Checking availability for $tileURL *****"
    if curl --head --silent --fail "$tileURL" > /dev/null; then
        echo "***** Downloading $tileURL *****"
        
        ## ***** Retry logic for download:
        while true; do
            aria2c -d "$dataDir" "$tileURL" --save-session log.txt
            
            if [ $(wc -l < log.txt) -eq 0 ]; then
                echo "Downloaded $tileURL successfully."
                break
            else
                echo "Errors detected in download, retrying..."
                sleep 10
            fi
        done
    else
        echo "***** $tileURL not available, skipping... *****"
    fi
}

## ***** Parallel download using xargs and aria2c:
export -f downloadTile
export dataDir  

cat "${tileListFile}" | xargs -P 4 -I {} bash -c 'downloadTile "$@"' _ {} "$dataDir"

# ## ***** Download tiles in serial using aria2:
# for tile in $tileList; do 
#     echo "***** checking availability for $tile *****"

#     if curl --head --silent --fail "$tile" > /dev/null; then
#         echo "***** downloading $tile *****"
        
#         while true; do
#             aria2c -d "$dataDir" "$tile" --save-session log.txt
            
#             if [ $(wc -l < log.txt) -eq 0 ]; then
#                 echo "Downloaded $tile successfully."
#                 break  
#             else
#                 echo "Errors detected in download, retrying..."
#                 sleep 10  
#             fi
#         done
#     else
#         echo "***** $tile not available, skipping... *****"
#     fi
# done

echo "COP-DEM download process completed at $(date)"

###############################################################################
###############################################################################
#              >>>>>>>>>>   End of code   <<<<<<<<<<                          #
###############################################################################
###############################################################################

