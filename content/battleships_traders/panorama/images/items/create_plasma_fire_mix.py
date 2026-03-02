#!/usr/bin/env python3
"""
Create composite images for plasma_fire_mix weapons.
Plasma image on top-left, fire image on bottom-right.
"""
from PIL import Image
import os

# Image pairs: (plasma_image, fire_image, output_name)
image_pairs = [
    ("plasma_bow_doubled.png", "fire_bow_doubled.png", "plasma_fire_bow.png"),
    ("plasma_two_bow_doubled.png", "fire_two_bow_doubled.png", "plasma_fire_two_bow.png"),
    ("plasma_three_bow_doubled.png", "fire_three_bow_doubled.png", "plasma_fire_three_bow.png"),
    ("plasma_ult_bow_final.png", "fire_ult_bow.png", "plasma_fire_ult_bow.png"),
]

def create_composite(plasma_path, fire_path, output_path):
    """Create a composite image with plasma on top-left and fire on bottom-right, split diagonally."""
    # Open both images
    plasma_img = Image.open(plasma_path).convert("RGBA")
    fire_img = Image.open(fire_path).convert("RGBA")
    
    # Get the bounding box of non-transparent content for each image
    plasma_bbox = plasma_img.getbbox()
    fire_bbox = fire_img.getbbox()
    
    if plasma_bbox is None:
        plasma_bbox = (0, 0, plasma_img.width, plasma_img.height)
    if fire_bbox is None:
        fire_bbox = (0, 0, fire_img.width, fire_img.height)
    
    # Calculate the content width (rightmost non-transparent pixel)
    plasma_content_width = plasma_bbox[2]
    fire_content_width = fire_bbox[2]
    
    # Get dimensions - use the maximum size to ensure both fit
    width = max(plasma_img.width, fire_img.width)
    height = max(plasma_img.height, fire_img.height)
    
    # Use the maximum actual content width for diagonal calculation
    content_width = max(plasma_content_width, fire_content_width)
    
    # Resize images to the same size if needed
    if plasma_img.size != (width, height):
        plasma_img = plasma_img.resize((width, height), Image.Resampling.LANCZOS)
    if fire_img.size != (width, height):
        fire_img = fire_img.resize((width, height), Image.Resampling.LANCZOS)
    
    # Create a mask for the diagonal split
    # Diagonal line from top-right of content area to bottom-left (0, height-1)
    mask = Image.new("L", (width, height), 0)
    pixels = mask.load()
    
    # Fill the mask: top-left portion (plasma) = 255, bottom-right portion (fire) = 0
    for y in range(height):
        for x in range(width):
            # Diagonal line from (content_width, 0) to (0, height)
            # Line equation: y/height = (content_width-x)/content_width
            # Simplified: y * content_width <= (content_width - x) * height
            if y * content_width <= height * (content_width - x):
                pixels[x, y] = 255
            else:
                pixels[x, y] = 0
    
    # Start with fire as base
    composite = fire_img.copy()
    
    # Paste plasma on top using the mask
    composite.paste(plasma_img, (0, 0), mask)
    
    # Save the result
    composite.save(output_path, "PNG")
    print(f"Created: {output_path} (content width: {content_width})")

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    for plasma_name, fire_name, output_name in image_pairs:
        plasma_path = os.path.join(script_dir, plasma_name)
        fire_path = os.path.join(script_dir, fire_name)
        output_path = os.path.join(script_dir, output_name)
        
        # Check if source images exist
        if not os.path.exists(plasma_path):
            print(f"Warning: {plasma_name} not found, skipping...")
            continue
        if not os.path.exists(fire_path):
            print(f"Warning: {fire_name} not found, skipping...")
            continue
        
        # Create composite
        create_composite(plasma_path, fire_path, output_path)
    
    print("\nAll composite images created successfully!")

if __name__ == "__main__":
    main()
