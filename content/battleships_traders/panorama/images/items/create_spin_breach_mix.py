from PIL import Image
import os

# Get the directory where this script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

# Define source image pairs and output names
image_pairs = [
    ("spin_bow_doubled.png", "breach_bow_doubled.png", "spin_breach_bow.png"),
    ("spin_two_bow_doubled.png", "breach_two_bow_doubled.png", "spin_breach_two_bow.png"),
    ("spin_three_bow_doubled.png", "breach_three_bow_doubled.png", "spin_breach_three_bow.png"),
    ("spin_ult_bow.png", "breach_ult_bow.png", "spin_breach_ult_bow.png")
]

def create_diagonal_composite(spin_path, breach_path, output_path):
    """
    Create a diagonal composite image with spin in top-left and breach in bottom-right.
    Uses actual content area (ignoring transparent padding) for diagonal calculation.
    """
    # Open images
    spin_img = Image.open(spin_path).convert("RGBA")
    breach_img = Image.open(breach_path).convert("RGBA")
    
    # Get bounding boxes of actual content (non-transparent areas)
    spin_bbox = spin_img.getbbox()
    breach_bbox = breach_img.getbbox()
    
    if not spin_bbox or not breach_bbox:
        print(f"Warning: One of the images has no visible content")
        return
    
    # Calculate content dimensions
    spin_content_width = spin_bbox[2] - spin_bbox[0]
    spin_content_height = spin_bbox[3] - spin_bbox[1]
    breach_content_width = breach_bbox[2] - breach_bbox[0]
    breach_content_height = breach_bbox[3] - breach_bbox[1]
    
    # Use the larger dimensions as the base
    width = max(spin_img.width, breach_img.width)
    height = max(spin_img.height, breach_img.height)
    
    # Resize if dimensions don't match
    if spin_img.size != (width, height):
        spin_img = spin_img.resize((width, height), Image.Resampling.LANCZOS)
        spin_bbox = spin_img.getbbox()
        spin_content_width = spin_bbox[2] - spin_bbox[0]
        spin_content_height = spin_bbox[3] - spin_bbox[1]
    
    if breach_img.size != (width, height):
        breach_img = breach_img.resize((width, height), Image.Resampling.LANCZOS)
        breach_bbox = breach_img.getbbox()
        breach_content_width = breach_bbox[2] - breach_bbox[0]
        breach_content_height = breach_bbox[3] - breach_bbox[1]
    
    # Create output image
    result = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    
    # Get pixel data
    spin_pixels = spin_img.load()
    breach_pixels = breach_img.load()
    result_pixels = result.load()
    
    # Calculate content center and dimensions for diagonal
    content_width = max(spin_content_width, breach_content_width)
    content_height = max(spin_content_height, breach_content_height)
    
    # Apply diagonal split: top-right to bottom-left
    # Spin visible in top-left, breach visible in bottom-right
    for y in range(height):
        for x in range(width):
            # Calculate relative position within content area
            x_rel = x - spin_bbox[0] if spin_bbox else x
            y_rel = y - spin_bbox[1] if spin_bbox else y
            
            # Diagonal formula: y * content_width <= content_height * (content_width - x_rel)
            # This creates a line from top-right to bottom-left
            if y_rel * content_width <= content_height * (content_width - x_rel):
                # Top-left area: use spin
                result_pixels[x, y] = spin_pixels[x, y]
            else:
                # Bottom-right area: use breach
                result_pixels[x, y] = breach_pixels[x, y]
    
    # Save the result
    result.save(output_path)
    print(f"Created: {output_path}")

# Process all image pairs
for spin_name, breach_name, output_name in image_pairs:
    spin_path = os.path.join(script_dir, spin_name)
    breach_path = os.path.join(script_dir, breach_name)
    output_path = os.path.join(script_dir, output_name)
    
    if not os.path.exists(spin_path):
        print(f"Error: {spin_name} not found")
        continue
    
    if not os.path.exists(breach_path):
        print(f"Error: {breach_name} not found")
        continue
    
    create_diagonal_composite(spin_path, breach_path, output_path)

print("\nAll images created successfully!")
