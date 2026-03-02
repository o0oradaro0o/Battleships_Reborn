#!/usr/bin/env python3
"""
Create fire_coal_mix weapon icons by combining fire and coal weapon images with diagonal split.
Diagonal line goes from top-right to bottom-left.
Fire weapon visible in TOP-LEFT, Coal weapon visible in BOTTOM-RIGHT.
"""

from PIL import Image
import os

def create_diagonal_composite(fire_path, coal_path, output_path):
    """
    Create a diagonal composite image with fire in top-left and coal in bottom-right.
    
    Args:
        fire_path: Path to fire weapon image
        coal_path: Path to coal weapon image
        output_path: Path to save composite image
    """
    # Open both images
    fire_img = Image.open(fire_path).convert('RGBA')
    coal_img = Image.open(coal_path).convert('RGBA')
    
    # Get image dimensions
    width, height = fire_img.size
    coal_width, coal_height = coal_img.size
    
    # Resize coal image if dimensions don't match
    if (coal_width, coal_height) != (width, height):
        coal_img = coal_img.resize((width, height), Image.Resampling.LANCZOS)
    
    # Get bounding box of actual content (non-transparent pixels)
    fire_bbox = fire_img.getbbox()
    if fire_bbox:
        content_left, content_top, content_right, content_bottom = fire_bbox
        content_width = content_right - content_left
        content_height = content_bottom - content_top
    else:
        # If no bbox, use full image
        content_left, content_top = 0, 0
        content_width, content_height = width, height
    
    # Create output image
    output = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    
    # For each pixel, determine if it's in the top-left (fire) or bottom-right (coal) region
    # Diagonal line equation: y * content_width <= content_height * (content_width - x)
    # This creates a line from top-right to bottom-left through the content area
    
    for y in range(height):
        for x in range(width):
            # Adjust coordinates relative to content area
            x_rel = x - content_left
            y_rel = y - content_top
            
            # Check which side of the diagonal line this pixel is on
            # Top-left region (fire): y * content_width <= content_height * (content_width - x)
            if y_rel * content_width <= content_height * (content_width - x_rel):
                # Use fire pixel
                output.putpixel((x, y), fire_img.getpixel((x, y)))
            else:
                # Use coal pixel
                output.putpixel((x, y), coal_img.getpixel((x, y)))
    
    # Save the output
    output.save(output_path, 'PNG')
    print(f"Created: {output_path}")

def main():
    # Get the directory where this script is located
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Define image pairs (fire, coal, output)
    image_configs = [
        ('fire_bow_doubled.png', 'coal_bow_doubled.png', 'fire_coal_bow.png'),
        ('fire_two_bow_doubled.png', 'coal_two_bow_doubled.png', 'fire_coal_two_bow.png'),
        ('fire_three_bow_doubled.png', 'coal_three_bow_doubled.png', 'fire_coal_three_bow.png'),
        ('fire_ult_bow.png', 'coal_ult_bow.png', 'fire_coal_ult_bow.png'),
    ]
    
    print("Creating fire_coal_mix weapon icons...")
    print("=" * 60)
    
    for fire_name, coal_name, output_name in image_configs:
        fire_path = os.path.join(script_dir, fire_name)
        coal_path = os.path.join(script_dir, coal_name)
        output_path = os.path.join(script_dir, output_name)
        
        # Check if source files exist
        if not os.path.exists(fire_path):
            print(f"ERROR: Fire image not found: {fire_path}")
            continue
        
        if not os.path.exists(coal_path):
            print(f"ERROR: Coal image not found: {coal_path}")
            continue
        
        # Create composite
        try:
            create_diagonal_composite(fire_path, coal_path, output_path)
        except Exception as e:
            print(f"ERROR creating {output_name}: {e}")
    
    print("=" * 60)
    print("Done! Remember to manually copy these images to:")
    print("game/battleships_traders/resource/flash3/images/items/")

if __name__ == '__main__':
    main()
