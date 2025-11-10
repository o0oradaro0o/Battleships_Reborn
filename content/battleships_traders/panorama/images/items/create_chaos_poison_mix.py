from PIL import Image
import os

# Define the base path for images
base_path = r"c:\Users\Lorne\Desktop\dota2Modding\Battleships_Reborn\content\battleships_traders\panorama\images\items"

# Define the image pairs and output names
image_pairs = [
    ("chaos_bow_doubled.png", "poison_bow_doubled.png", "chaos_poison_bow.png"),
    ("chaos_two_bow_doubled.png", "poison_two_bow_doubled.png", "chaos_poison_two_bow.png"),
    ("chaos_three_bow_doubled.png", "poison_three_bow_doubled.png", "chaos_poison_three_bow.png"),
    ("chaos_ult_bow.png", "poison_ult_bow.png", "chaos_poison_ult_bow.png")
]

def create_diagonal_composite(chaos_path, poison_path, output_path):
    """
    Creates a diagonal composite image with chaos weapon in top-left
    and poison weapon in bottom-right
    """
    # Load images
    chaos_img = Image.open(chaos_path).convert("RGBA")
    poison_img = Image.open(poison_path).convert("RGBA")
    
    # Get dimensions (should be same for both)
    width, height = chaos_img.size
    
    # Ensure both images are same size
    if poison_img.size != chaos_img.size:
        poison_img = poison_img.resize(chaos_img.size, Image.Resampling.LANCZOS)
    
    # Get bounding box of actual content (non-transparent pixels)
    chaos_bbox = chaos_img.getbbox()
    if chaos_bbox:
        content_left, content_top, content_right, content_bottom = chaos_bbox
        content_width = content_right - content_left
        content_height = content_bottom - content_top
    else:
        content_left, content_top = 0, 0
        content_width, content_height = width, height
    
    # Create output image
    result = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    
    # Create mask for diagonal split
    # Formula: y * content_width <= content_height * (content_width - x_rel)
    # This creates a line from top-right to bottom-left of content area
    for y in range(height):
        for x in range(width):
            # Calculate relative position within content area
            x_rel = x - content_left
            y_rel = y - content_top
            
            # Check if we're within content bounds
            if 0 <= x_rel < content_width and 0 <= y_rel < content_height:
                # Diagonal formula: top-left gets chaos, bottom-right gets poison
                if y_rel * content_width <= content_height * (content_width - x_rel):
                    # Top-left area: use chaos pixel
                    result.putpixel((x, y), chaos_img.getpixel((x, y)))
                else:
                    # Bottom-right area: use poison pixel
                    result.putpixel((x, y), poison_img.getpixel((x, y)))
            else:
                # Outside content area, check which image has non-transparent pixel
                chaos_pixel = chaos_img.getpixel((x, y))
                poison_pixel = poison_img.getpixel((x, y))
                if chaos_pixel[3] > 0:
                    result.putpixel((x, y), chaos_pixel)
                elif poison_pixel[3] > 0:
                    result.putpixel((x, y), poison_pixel)
    
    # Save result
    result.save(output_path)
    print(f"Created: {output_path}")

# Process all image pairs
for chaos_file, poison_file, output_file in image_pairs:
    chaos_path = os.path.join(base_path, chaos_file)
    poison_path = os.path.join(base_path, poison_file)
    output_path = os.path.join(base_path, output_file)
    
    if os.path.exists(chaos_path) and os.path.exists(poison_path):
        create_diagonal_composite(chaos_path, poison_path, output_path)
    else:
        if not os.path.exists(chaos_path):
            print(f"Warning: {chaos_file} not found")
        if not os.path.exists(poison_path):
            print(f"Warning: {poison_file} not found")

print("\nAll chaos_poison_mix images created successfully!")
