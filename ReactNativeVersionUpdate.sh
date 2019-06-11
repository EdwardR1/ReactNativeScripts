#!/bin/bash

#Update the version number. Scan and automatically update the version code. User Inputs version name.
updateVersionValues() {
    filename="app/build.gradle"
    oldVersionCode=0
    oldVersionName=0
    while IFS= read -r line; do
        value=$line
        if [[ "$line" =~ "versionCode " ]]; then
            oldVersionCode=$(echo $value | cut -d' ' -f 2)
            echo $oldVersionCode
        elif [[ "$line" =~ "versionName " ]]; then
            oldVersionName=$(echo $value | cut -d' ' -f 2)
        fi
    done <"$filename"

    echo "Version Code:"

    echo "Old versionCode was:" $oldVersionCode
    newVersionCode=$((oldVersionCode + 1))
    echo "New versionCode is:" $newVersionCode

    echo "Version Name:"

    echo "Old versionName was:" $oldVersionName
    read -p "New Version Name: " newVersionName

    oldVCString="versionCode $oldVersionCode"
    oldVNString="versionName $oldVersionName"

    newVCString="versionCode $newVersionCode"
    newVNString="versionName \"$newVersionName\""

    sed -i "" "s|$oldVCString|$newVCString|" $filename
    sed -i "" "s|$oldVNString|$newVNString|" $filename

    echo "Done!"
}

# Check if run inside an android folder, if not, will stop. If so, continue with the provided function
androidFolderCheck() {
    cont=$(pwd)
    if [[ $cont =~ "android" ]]; then
        echo "Android folder found! Executing function"
        $1
    else
        echo "Android folder not found! Stopping"
    fi

}

main() {
    androidFolderCheck updateVersionValues
}

main
