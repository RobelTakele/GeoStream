#!/bin/sh
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

# Check for required dependencies
check_dependencies() {
    for cmd in curl aria2c; do
        if ! command -v "$cmd" > /dev/null; then
            echo "Error: $cmd is not installed. Please install it to continue." >&2
            exit 1
        fi
    done
}

# Call the dependency check
check_dependencies

# Default values
rootDir="/home/robel/WSC/"
dataDir="$rootDir/data/Elevation/COPDEM-GLO90/Tiles/"
latStart=-46  # Southern boundary (°S)
latEnd=38     # Northern boundary (°N)
lonStart=-25  # Western boundary (°W)
lonEnd=64     # Eastern boundary (°E)

# Parse input arguments
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
            echo "${getCOPDEM.sh} 0.1.0"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Create the data directory if it does not exist
mkdir -p "$dataDir"

# Function to generate the list of tile names
makeTileList() {
    local latStart=$1
    local latEnd=$2
    local lonStart=$3
    local lonEnd=$4
    local tileList=()

    for (( lat=latStart; lat<=latEnd; lat++ )); do
        for (( lon=lonStart; lon<=lonEnd; lon++ )); do
            # Format latitude (N or S)
            if [ $lat -ge 0 ]; then
                latStr=$(printf "N%02d" $lat)
            else
                latStr=$(printf "S%02d" $(( -lat )))
            fi

            # Format longitude (E or W)
            if [ $lon -ge 0 ]; then
                lonStr=$(printf "E%03d" $lon)
            else
                lonStr=$(printf "W%03d" $(( -lon )))
            fi

            # Generate the tile name and add to the list
            tileName=$(printf "Copernicus_DSM_30_%s_00_%s_00.tar" "$latStr" "$lonStr")
            tileList+=("$tileName")
        done
    done

    echo "${tileList[@]}"
}

# Generate the list of tiles
africaTiles=$(makeTileList $latStart $latEnd $lonStart $lonEnd)

# Save the tile names to a file
echo "$africaTiles" > "$dataDir/Africa_Copernicus_GLO90_Tile_List.txt"

# Download tiles using aria2
for tile in $africaTiles; do 
    echo "***** checking availability for $tile *****"
    fileURL="https://prism-dem-open.copernicus.eu/pd-desk-open-access/prismDownload/COP-DEM_GLO-90-DGED__2023_1/$tile"
    
    # Check if the file exists
    if curl --head --silent --fail "$fileURL" > /dev/null; then
        echo "***** downloading $tile *****"
        
        # Download the tile with retry logic
        while true; do
            aria2c -o "$dataDir/$tile" "$fileURL" --save-session log.txt
            
            # Check for errors in the log
            if [ $(wc -l < log.txt) -eq 0 ]; then
                echo "Downloaded $tile successfully."
                break  # Exit the retry loop if download is successful
            else
                echo "Errors detected in download, retrying..."
                sleep 10  # Wait before retrying
            fi
        done
    else
        echo "***** $tile not available, skipping... *****"
    fi
done

###############################################################################
###############################################################################
#              >>>>>>>>>>   End of code   <<<<<<<<<<                          #
###############################################################################
###############################################################################
