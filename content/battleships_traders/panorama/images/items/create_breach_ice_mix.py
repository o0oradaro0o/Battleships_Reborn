from PIL import Image
import os

def create_hybrid_image(breach_path, ice_path, output_path):
    """
    Create hybrid weapon icon with diagonal split.
    Top-right: breach weapon
    Bottom-left: ice weapon
    """
    breach = Image.open(breach_path).convert("RGBA")
    ice = Image.open(ice_path).convert("RGBA")
    
    # Use the maximum dimensions
    width = max(breach.width, ice.width)
    height = max(breach.height, ice.height)
    
    # Resize images if they don't match
    if breach.size != (width, height):
        breach_resized = Image.new("RGBA", (width, height), (0, 0, 0, 0))
        breach_resized.paste(breach, (0, 0))
        breach = breach_resized
    
    if ice.size != (width, height):
        ice_resized = Image.new("RGBA", (width, height), (0, 0, 0, 0))
        ice_resized.paste(ice, (0, 0))
        ice = ice_resized
    
    result = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    
    # Get content areas (non-transparent regions)
    breach_bbox = breach.getbbox()
    ice_bbox = ice.getbbox()
    
    if breach_bbox and ice_bbox:
        breach_left, breach_top, breach_right, breach_bottom = breach_bbox
        ice_left, ice_top, ice_right, ice_bottom = ice_bbox
        
        content_width = max(breach_right - breach_left, ice_right - ice_left)
        content_height = max(breach_bottom - breach_top, ice_bottom - ice_top)
        
        for y in range(height):
            for x in range(width):
                x_rel = x - min(breach_left, ice_left)
                
                # Diagonal split formula: top-right = breach, bottom-left = ice
                if y * content_width <= content_height * (content_width - x_rel):
                    pixel = breach.getpixel((x, y))
                else:
                    pixel = ice.getpixel((x, y))
                
                result.putpixel((x, y), pixel)
    
    result.save(output_path, "PNG")
    print(f"Created: {output_path}")

# Image pairs
images = [
    ("breach_bow.png", "ice_bow.png", "breach_ice_bow.png"),
    ("breach_two_bow.png", "ice_two_bow.png", "breach_ice_two_bow.png"),
    ("breach_three_bow.png", "ice_three_bow.png", "breach_ice_three_bow.png"),
    ("breach_ult_bow.png", "ice_ult_bow.png", "breach_ice_ult_bow.png")
]

for breach_img, ice_img, output_img in images:
    create_hybrid_image(breach_img, ice_img, output_img)

print("All images created successfully!")
