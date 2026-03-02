#!/usr/bin/env python3
"""
Create diagonal composite images for poison_light_mix weapons.
Combines poison weapon images (top-left) with light weapon images (bottom-right).
"""

from PIL import Image
import os

# Define image pairs: (poison_image, light_image, output_name)
image_pairs = [
    ("poison_bow_doubled.png", "light_bow_doubled.png", "poison_light_bow.png"),
    ("poison_two_bow_doubled.png", "light_two_bow_doubled.png", "poison_light_two_bow.png"),
    ("poison_three_bow_doubled.png", "light_three_bow_doubled.png", "poison_light_three_bow.png"),
    ("poison_ult_bow.png", "light_ult_bow.png", "poison_light_ult_bow.png"),
]

def create_diagonal_composite(poison_path, light_path, output_path):
    """
    Create a diagonal composite image with poison in top-left and light in bottom-right.
    Uses diagonal split from top-right to bottom-left based on content area.
    """
    # Load images
    poison_img = Image.open(poison_path).convert("RGBA")
    light_img = Image.open(light_path).convert("RGBA")
    
    # Get content bounding boxes (exclude transparent padding)
    poison_bbox = poison_img.getbbox()
    light_bbox = light_img.getbbox()
    
    # If images have different sizes, resize to match
    if poison_img.size != light_img.size:
        # Use the larger dimensions
        max_width = max(poison_img.width, light_img.width)
        max_height = max(poison_img.height, light_img.height)
        
        if poison_img.size != (max_width, max_height):
            new_poison = Image.new("RGBA", (max_width, max_height), (0, 0, 0, 0))
            new_poison.paste(poison_img, (0, 0))
            poison_img = new_poison
            poison_bbox = poison_img.getbbox()
            
        if light_img.size != (max_width, max_height):
            new_light = Image.new("RGBA", (max_width, max_height), (0, 0, 0, 0))
            new_light.paste(light_img, (0, 0))
            light_img = new_light
            light_bbox = light_img.getbbox()
    
    # Create output image
    width, height = poison_img.size
    result = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    
    # Get content dimensions (use poison bbox for consistency)
    if poison_bbox:
        content_x1, content_y1, content_x2, content_y2 = poison_bbox
        content_width = content_x2 - content_x1
        content_height = content_y2 - content_y1
    else:
        content_x1, content_y1 = 0, 0
        content_width = width
        content_height = height
    
    # Apply diagonal mask: y * content_width <= content_height * (content_width - x_rel)
    # This creates a line from top-right to bottom-left
    for y in range(height):
        for x in range(width):
            # Calculate relative position within content area
            x_rel = x - content_x1 if x >= content_x1 else 0
            y_rel = y - content_y1 if y >= content_y1 else 0
            
            # Apply diagonal formula
            # Top-left side (poison): y * content_width <= content_height * (content_width - x_rel)
            if y_rel * content_width <= content_height * (content_width - x_rel):
                result.putpixel((x, y), poison_img.getpixel((x, y)))
            else:
                result.putpixel((x, y), light_img.getpixel((x, y)))
    
    # Save result
    result.save(output_path)
    print(f"Created: {output_path}")

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    for poison_name, light_name, output_name in image_pairs:
        poison_path = os.path.join(script_dir, poison_name)
        light_path = os.path.join(script_dir, light_name)
        output_path = os.path.join(script_dir, output_name)
        
        if not os.path.exists(poison_path):
            print(f"Warning: Poison image not found: {poison_path}")
            continue
        
        if not os.path.exists(light_path):
            print(f"Warning: Light image not found: {light_path}")
            continue
        
        create_diagonal_composite(poison_path, light_path, output_path)
    
    print("\nAll images created successfully!")

if __name__ == "__main__":
    main()
