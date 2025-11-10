#!/usr/bin/env python3
"""
Create coal_chaos_mix weapon images by combining coal and chaos weapon images
with a diagonal split (top-left = coal, bottom-right = chaos).
"""

from PIL import Image
import os

# Base directory for images
base_dir = r"c:\Users\Lorne\Desktop\dota2Modding\Battleships_Reborn\content\battleships_traders\panorama\images\items"

# Image pairs: (coal_source, chaos_source, output_name)
image_pairs = [
    ("coal_bow_doubled.png", "chaos_bow_doubled.png", "coal_chaos_bow.png"),
    ("coal_two_bow_doubled.png", "chaos_two_bow_doubled.png", "coal_chaos_two_bow.png"),
    ("coal_three_bow_doubled.png", "chaos_three_bow_doubled.png", "coal_chaos_three_bow.png"),
    ("coal_ult_bow.png", "chaos_ult_bow.png", "coal_chaos_ult_bow.png"),
]

def create_diagonal_composite(coal_path, chaos_path, output_path):
    """
    Create a composite image with diagonal split:
    - Coal image in top-left
    - Chaos image in bottom-right
    - Diagonal line from top-right to bottom-left
    """
    # Load images
    coal_img = Image.open(coal_path).convert("RGBA")
    chaos_img = Image.open(chaos_path).convert("RGBA")
    
    # Get dimensions (assume both images are same size)
    width, height = coal_img.size
    
    # Ensure chaos image matches coal image size
    if chaos_img.size != coal_img.size:
        chaos_img = chaos_img.resize(coal_img.size, Image.LANCZOS)
    
    # Get the actual content bounding box (ignore transparent padding)
    coal_bbox = coal_img.getbbox()
    if coal_bbox:
        content_left, content_top, content_right, content_bottom = coal_bbox
        content_width = content_right - content_left
        content_height = content_bottom - content_top
    else:
        # Fallback to full image if no bbox found
        content_left, content_top = 0, 0
        content_width, content_height = width, height
    
    # Create output image starting with coal
    output = coal_img.copy()
    
    # Apply diagonal split: top-left = coal, bottom-right = chaos
    # Diagonal formula: y * content_width <= content_height * (content_width - x_rel)
    # where x_rel is relative to content area
    
    for y in range(height):
        for x in range(width):
            # Calculate position relative to content area
            x_rel = x - content_left
            y_rel = y - content_top
            
            # Check if we're within the content area
            if (x_rel >= 0 and x_rel < content_width and 
                y_rel >= 0 and y_rel < content_height):
                # Diagonal split: if below the diagonal line, use chaos
                if y_rel * content_width > content_height * (content_width - x_rel):
                    # Below diagonal = chaos (bottom-right)
                    chaos_pixel = chaos_img.getpixel((x, y))
                    output.putpixel((x, y), chaos_pixel)
    
    # Save output
    output.save(output_path, "PNG")
    print(f"Created: {output_path}")

def main():
    """Generate all coal_chaos_mix weapon images."""
    os.chdir(base_dir)
    
    print("Creating coal_chaos_mix weapon images...")
    print(f"Working directory: {base_dir}")
    print()
    
    for coal_src, chaos_src, output_name in image_pairs:
        coal_path = os.path.join(base_dir, coal_src)
        chaos_path = os.path.join(base_dir, chaos_src)
        output_path = os.path.join(base_dir, output_name)
        
        # Check if source files exist
        if not os.path.exists(coal_path):
            print(f"ERROR: Coal source not found: {coal_path}")
            continue
        if not os.path.exists(chaos_path):
            print(f"ERROR: Chaos source not found: {chaos_path}")
            continue
        
        # Create composite
        try:
            create_diagonal_composite(coal_path, chaos_path, output_path)
        except Exception as e:
            print(f"ERROR creating {output_name}: {e}")
    
    print()
    print("Image creation complete!")
    print()
    print("Next step: Copy images to game directory")
    print("Run in PowerShell:")
    print('Copy-Item "c:\\Users\\Lorne\\Desktop\\dota2Modding\\Battleships_Reborn\\content\\battleships_traders\\panorama\\images\\items\\coal_chaos_*.png" -Destination "c:\\Users\\Lorne\\Desktop\\dota2Modding\\Battleships_Reborn\\game\\battleships_traders\\resource\\flash3\\images\\items\\"')

if __name__ == "__main__":
    main()
