# React Native Scripts

## Scripts to update React Native information or to speed up to process

## Scripts will only run if they are called inside the folder android folder in a pure React Native project.

*Android Rename Package*

    Call with `bash <(curl -s https://raw.githubusercontent.com/EdwardR1/ReactNativeScripts/master/ReactNativeAndroidRenamePackage.sh)`
    Key usage if `expo eject` returns an incorrect package.
    Program will request for a new package name.
    Program will replace and update the references.

*Version Update*

    Call with `bash <(curl -s https://raw.githubusercontent.com/EdwardR1/ReactNativeScripts/master/ReactNativeVersionUpdate.sh)`
    Key usage right before publishing react-native app, with a requirement of an updated build number.
    Will ask for new Version Name.
    Program will increment the version code and replace the version name.