#!/bin/bash

# Set the path to the images folder
img_folder=~/Pictures/Wallpapers

# Get all images in the folder
images=($img_folder/*)

# Check if 'kitty' is available
if command -v kitty &> /dev/null; then
    # Set up variables for grid layout
    cols=3  # Number of columns in the grid
    rows=$(( (${#images[@]} + $cols - 1) / $cols )) # Calculate number of rows needed

    # Clear the terminal
    clear

    # Display images in a grid layout
    for ((i = 0; i < $rows; i++)); do
        for ((j = 0; j < $cols; j++)); do
            index=$((i * $cols + j))
            if [ $index -lt ${#images[@]} ]; then
                img="${images[$index]}"
                echo -n "[$index] "  # Display image index
                kitty +kitten icat --silent "$img"  # Display image using kitty
            fi
        done
        # Move cursor to the next line
        echo
    done
else
    echo "kitty not found. Displaying filenames only."
    for img in "${images[@]}"; do
        echo "$(basename $img)"
    done
fi

# Use fzf to prompt the user to select an image
selected_image=$(printf "%s\n" "${images[@]}" | fzf --prompt="Select an image: ")

# Show the selected image using kitty +kitten icat if available
if command -v kitty &> /dev/null; then
    kitty +kitten icat "$selected_image"
else
    echo "Image preview not available. Displaying filename only."
fi

# Ask if the user wants to set the selected image as wallpaper
read -p "Do you want to set this image as wallpaper? (y/n): " choice
if [ "$choice" == "y" ]; then
    swww img "$selected_image"
    echo "Wallpaper set successfully!"
else
    echo "Wallpaper not changed."
fi

