"""
Creates composite images for light_spin_mix weapons by combining light and spin weapon images.
Uses a diagonal split from top-right to bottom-left.
Light weapon appears in TOP-LEFT, Spin weapon appears in BOTTOM-RIGHT.
"""

from PIL import Image
import os

# Get the directory where this script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

# Define the weapon pairs to combine
weapon_pairs = [
    ("light_bow_doubled.png", "spin_bow_doubled.png", "light_spin_bow.png"),
    ("light_two_bow_doubled.png", "spin_two_bow_doubled.png", "light_spin_two_bow.png"),
    ("light_three_bow_doubled.png", "spin_three_bow_doubled.png", "light_spin_three_bow.png"),
    ("light_ult_bow.png", "spin_ult_bow.png", "light_spin_ult_bow.png"),
]

def create_diagonal_composite(light_path, spin_path, output_path):
    """
    Creates a composite image with a diagonal split from top-right to bottom-left.
    Light image visible in TOP-LEFT area, Spin image visible in BOTTOM-RIGHT area.
    Uses getbbox() to find actual content area.
    """
    # Open both images
    light_img = Image.open(light_path).convert("RGBA")
    spin_img = Image.open(spin_path).convert("RGBA")
    
    # Get the bounding boxes of actual content (non-transparent areas)
    light_bbox = light_img.getbbox()
    spin_bbox = spin_img.getbbox()
    
    if light_bbox is None or spin_bbox is None:
        print(f"Warning: One of the images is completely transparent!")
        return
    
    # Get dimensions - use the larger of the two
    width = max(light_img.width, spin_img.width)
    height = max(light_img.height, spin_img.height)
    
    # Resize images if needed to match dimensions
    if light_img.size != (width, height):
        new_light = Image.new("RGBA", (width, height), (0, 0, 0, 0))
        new_light.paste(light_img, (0, 0))
        light_img = new_light
        
    if spin_img.size != (width, height):
        new_spin = Image.new("RGBA", (width, height), (0, 0, 0, 0))
        new_spin.paste(spin_img, (0, 0))
        spin_img = new_spin
    
    # Recalculate bounding boxes after resize
    light_bbox = light_img.getbbox()
    spin_bbox = spin_img.getbbox()
    
    # Calculate content dimensions
    light_x1, light_y1, light_x2, light_y2 = light_bbox
    spin_x1, spin_y1, spin_x2, spin_y2 = spin_bbox
    
    content_width = max(light_x2 - light_x1, spin_x2 - spin_x1)
    content_height = max(light_y2 - light_y1, spin_y2 - spin_y1)
    
    # Create the composite image
    composite = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    
    # Apply diagonal mask - diagonal line from top-right to bottom-left
    # Formula: for content area, y * content_width <= content_height * (content_width - x_rel)
    # where x_rel is relative to content start
    
    light_pixels = light_img.load()
    spin_pixels = spin_img.load()
    composite_pixels = composite.load()
    
    for y in range(height):
        for x in range(width):
            # Check if we're in the content area
            in_light_content = (light_x1 <= x < light_x2 and light_y1 <= y < light_y2)
            in_spin_content = (spin_x1 <= x < spin_x2 and spin_y1 <= y < spin_y2)
            
            if in_light_content or in_spin_content:
                # Calculate position relative to content area
                x_rel = x - min(light_x1, spin_x1)
                y_rel = y - min(light_y1, spin_y1)
                
                # Diagonal formula: TOP-LEFT gets light, BOTTOM-RIGHT gets spin
                # Line goes from top-right corner (content_width, 0) to bottom-left (0, content_height)
                # Point is in TOP-LEFT if: y * content_width <= content_height * (content_width - x_rel)
                if y_rel * content_width <= content_height * (content_width - x_rel):
                    # TOP-LEFT area - use light weapon
                    if in_light_content:
                        composite_pixels[x, y] = light_pixels[x, y]
                else:
                    # BOTTOM-RIGHT area - use spin weapon
                    if in_spin_content:
                        composite_pixels[x, y] = spin_pixels[x, y]
            
    # Save the composite image
    composite.save(output_path)
    print(f"Created: {os.path.basename(output_path)}")

# Create all composite images
print("Creating light_spin_mix composite images...")
print("=" * 60)

for light_file, spin_file, output_file in weapon_pairs:
    light_path = os.path.join(script_dir, light_file)
    spin_path = os.path.join(script_dir, spin_file)
    output_path = os.path.join(script_dir, output_file)
    
    if not os.path.exists(light_path):
        print(f"ERROR: Light weapon image not found: {light_file}")
        continue
    
    if not os.path.exists(spin_path):
        print(f"ERROR: Spin weapon image not found: {spin_file}")
        continue
    
    create_diagonal_composite(light_path, spin_path, output_path)

print("=" * 60)
print("All composite images created successfully!")
print("\nNext step: Copy images to flash3 directory using PowerShell:")
print('Copy-Item "c:\\Users\\Lorne\\Desktop\\dota2Modding\\Battleships_Reborn\\content\\battleships_traders\\panorama\\images\\items\\light_spin_*.png" -Destination "c:\\Users\\Lorne\\Desktop\\dota2Modding\\Battleships_Reborn\\game\\battleships_traders\\resource\\flash3\\images\\items\\"')
