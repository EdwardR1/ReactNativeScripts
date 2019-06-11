#!/bin/bash

# Replace values. Param 1: value to be replaced. Param 2: Value to replace. Param 3: File
replace() {
    sed -i -e s/$1/$2/g $3
}

# Count the occurrences of periods
count() {
    string=$1
    char="."
    a=$(echo "${string}" | awk -F"${char}" '{print NF-1}')
    return $((a + 1))
}

# Retrieve the current package
getPackage() {
    filename="app/src/main/AndroidManifest.xml"
    while IFS= read -r line; do
        if [[ "$line" =~ "package=" ]]; then
            echo $line | cut -d '"' -f 2
        fi
    done <"$filename"
}

# Separate the values from the package and store into an array
substring() {
    declare -a packageNameArray
    string=$1
    count $1
    size=$?
    for ((i = 1; i <= $size; i++)); do
        a=$(echo $string | cut -d'.' -f $i)
        packageNameArray=(${packageNameArray[@]} $a)
    done

    packagename=""

    for i in ${packageNameArray[@]}; do
        packagename+="/"$i
    done

    echo $packagename
}

# Assuming being called in the android folder
# Update the values from the packages with the new package name. User inputs the new package name.
PackageRename() {
    oldPackageName=$(getPackage)
    echo "Old package name is:" $oldPackageName
    read -p "What is the name of the new package? " newPackageName

    oldPackageDirectory=$(substring $oldPackageName)
    newPackageDirectory=$(substring $newPackageName)

    oldPackageCount=$(count $oldPackageName)
    oldPackageLength=$?

    newPackageCount=$(count $newPackageName)
    newPackageLength=$?

    declare -a locations

    locations=(app/src/main/java$newPackageDirectory/MainActivity.java app/src/main/java$newPackageDirectory/MainApplication.java app/src/main/AndroidManifest.xml app/build.gradle app/BUCK)

    subNew=""
    for ((i = 2; i <= $((newPackageLength + 1)); i++)); do
        subNew+=$(echo $newPackageDirectory | cut -d'/' -f $i)"/"
        mkdir app/src/main/java/$subNew
    done

    mv app/src/main/java$oldPackageDirectory/MainActivity.java app/src/main/java$newPackageDirectory/MainActivity.java

    mv app/src/main/java$oldPackageDirectory/MainApplication.java app/src/main/java$newPackageDirectory/MainApplication.java

    declare -a locationsToRemove
    subOld=""

    for ((i = 2; i <= $((oldPackageLength + 1)); i++)); do
        subOld+=$(echo $oldPackageDirectory | cut -d'/' -f $i)"/"
        locationsToRemove=(${locationsToRemove[@]} $subOld)
    done

    for ((i = ${#locationsToRemove[@]} - 1; i >= 0; i--)); do
        rmdir app/src/main/java/${locationsToRemove[$i]}
    done

    for i in "${locations[@]}"; do
        replace $oldPackageName $newPackageName $i
    done

    declare -a removeEdits
    for i in ${locations[@]}; do
        removeEdits=(${removeEdits[@]} $i-e)

    done

    for i in ${removeEdits[@]}; do
        rm $i
    done

    # ./gradlew clean
    echo "Done! All references updated!"

}

# Check whether the function is called in the android folder of the project
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
    androidFolderCheck PackageRename
}

main
