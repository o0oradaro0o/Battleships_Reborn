from PIL import Image
import os

def create_hybrid_image(ice_path, wind_path, output_path):
    """
    Create hybrid weapon icon with diagonal split.
    Top-right: ice weapon
    Bottom-left: wind weapon
    """
    ice = Image.open(ice_path).convert("RGBA")
    wind = Image.open(wind_path).convert("RGBA")
    
    # Handle different image sizes
    max_width = max(ice.width, wind.width)
    max_height = max(ice.height, wind.height)
    
    # Resize images if needed
    if ice.width != max_width or ice.height != max_height:
        new_ice = Image.new("RGBA", (max_width, max_height), (0, 0, 0, 0))
        new_ice.paste(ice, (0, 0))
        ice = new_ice
    
    if wind.width != max_width or wind.height != max_height:
        new_wind = Image.new("RGBA", (max_width, max_height), (0, 0, 0, 0))
        new_wind.paste(wind, (0, 0))
        wind = new_wind
    
    width = max_width
    height = max_height
    result = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    
    # Get content areas (non-transparent regions)
    ice_bbox = ice.getbbox()
    wind_bbox = wind.getbbox()
    
    if ice_bbox and wind_bbox:
        ice_left, ice_top, ice_right, ice_bottom = ice_bbox
        wind_left, wind_top, wind_right, wind_bottom = wind_bbox
        
        content_width = max(ice_right - ice_left, wind_right - wind_left)
        content_height = max(ice_bottom - ice_top, wind_bottom - wind_top)
        
        for y in range(height):
            for x in range(width):
                x_rel = x - min(ice_left, wind_left)
                
                # Diagonal split formula: top-right = ice, bottom-left = wind
                if y * content_width <= content_height * (content_width - x_rel):
                    pixel = ice.getpixel((x, y))
                else:
                    pixel = wind.getpixel((x, y))
                
                result.putpixel((x, y), pixel)
    
    result.save(output_path, "PNG")
    print(f"Created: {output_path}")

# Image pairs
images = [
    ("ice_bow.png", "wind_bow.png", "ice_wind_bow.png"),
    ("ice_two_bow.png", "wind_two_bow.png", "ice_wind_two_bow.png"),
    ("ice_three_bow.png", "wind_three_bow.png", "ice_wind_three_bow.png"),
    ("ice_ult_bow.png", "wind_ult_bow.png", "ice_wind_ult_bow.png")
]

for ice_img, wind_img, output_img in images:
    if os.path.exists(ice_img) and os.path.exists(wind_img):
        create_hybrid_image(ice_img, wind_img, output_img)
    else:
        print(f"Warning: Missing source images for {output_img}")
        if not os.path.exists(ice_img):
            print(f"  - {ice_img} not found")
        if not os.path.exists(wind_img):
            print(f"  - {wind_img} not found")

print("\nAll images processed!")
print("\nNext step: Copy the generated images to flash3 directory:")
print("Copy-Item ice_wind_*.png -Destination ../../../../../game/battleships_traders/resource/flash3/images/items/")
