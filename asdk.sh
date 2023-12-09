#!/bin/bash

# Check if Android SDK is already installed
if [ -d "$HOME/Android/Sdk" ]; then
  echo "Android SDK is already installed"
else
  # Download the latest version of the Android SDK
  echo "Downloading Android SDK..."
  wget https://dl.google.com/android/repository/commandlinetools-latest.zip

  # Unzip the Android SDK
  echo "Unzipping Android SDK..."
  unzip commandlinetools-latest.zip

  # Move the Android SDK to the user's home directory
  echo "Moving Android SDK to user's home directory..."
  mv commandlinetools-latest $HOME/Android/Sdk
fi

# Update the bashrc file
echo "Updating bashrc file..."
echo "export PATH=$HOME/Android/Sdk/tools:$HOME/Android/Sdk/platform-tools" >> ~/.bashrc

# Reload the bashrc file
source ~/.bashrc

# Install the latest version of Flutter
echo "Installing Flutter..."
flutter doctor
