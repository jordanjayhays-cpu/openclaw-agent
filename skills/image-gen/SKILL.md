---
name: image-gen
description: Generate images using Pollinations.ai (free, no API key needed). Use when Jordan needs thumbnails, visuals, or images for content projects like PK Music thumbnails, Neurotech content, or Marketing materials.
user-invocable: true
allowed-tools: "Read Write Edit Bash Glob Grep"
---

# Image Generation Skill

Generate images instantly using Pollinations.ai — free, no API key required.

## Quick Use

Generate a URL directly:
```
https://image.pollinations.ai/prompt/{URL_ENCODED_PROMPT}?width=1280&height=720&nologo=true
```

Or use the Python helper below.

## Generate from Prompt

```python
import urllib.request
import urllib.parse

def generate_image(prompt: str, width: int = 1280, height: int = 720, 
                  model: str = "flux", seed: int = None) -> str:
    """Generate an image and return the URL."""
    params = f"width={width}&height={height}&nologo=true&model={model}"
    if seed:
        params += f"&seed={seed}"
    encoded = urllib.parse.quote(prompt)
    url = f"https://image.pollinations.ai/prompt/{encoded}?{params}"
    return url

# Examples:
url = generate_image("Professional thumbnail for PISCO staffing project", width=1280, height=720)
print(f"Image URL: {url}")
```

## Image Sizes

| Use Case | Width | Height |
|----------|-------|--------|
| LinkedIn post | 1200 | 627 |
| YouTube thumbnail | 1280 | 720 |
| Twitter/X post | 1200 | 675 |
| Instagram square | 1080 | 1080 |
| PK Music thumbnail | 1280 | 720 |
| Neurotech banner | 1920 | 400 |

## Jordan's Common Prompts

### PK Music Thumbnails
- "Dark moody thumbnail for Philosophy King song about [theme], artistic hip-hop album cover style"
- "Neon glowing album cover [song title] in style of [reference]"

### Neurotech Content
- "Scientific infographic about consciousness and AI, clean modern design, blue and purple gradient"
- "Brain neural network visualization for YouTube thumbnail about [topic]"

### PISCO / Business
- "Professional LinkedIn thumbnail for Filipino staffing project, corporate clean design"
- "Modern business infographic showing hotel staffing solution"

### Marketing
- "Clean minimalist ad creative for [product], [color] theme, modern design"

## Models Available

- `flux` (default) — best quality
- `turbo` — faster generation
- `nova` — anime/creative style

## Download to File

```bash
curl -L "https://image.pollinations.ai/prompt/$(echo "your prompt" | sed 's/ /+/g')?width=1280&height=720" -o image.png
```

## Save Generated Image

```python
import urllib.request, os

def save_image(prompt: str, filename: str = "generated.png", 
               width: int = 1280, height: int = 720):
    """Generate and save an image."""
    encoded = urllib.parse.quote(prompt)
    url = f"https://image.pollinations.ai/prompt/{encoded}?width={width}&height={height}&nologo=true"
    urllib.request.urlretrieve(url, filename)
    size = os.path.getsize(filename)
    print(f"Saved {filename} ({size/1024:.0f} KB) — {url}")
    return filename
```

## Jordan Projects Quick Prompts

### PK Music
- Album art: `Dark moody hip-hop album cover "[song title]", Philosophy King style`
- Thumbnail: `YouTube thumbnail for "[song title]" by Philosophy King, dark dramatic lighting`

### Neurotech
- Banner: `Scientific YouTube banner about [topic], modern neuroscience aesthetic, blue purple`
- Thumbnail: `YouTube thumbnail about [consciousness/AI topic], brain visualization`

### PISCO
- LinkedIn: `Professional thumbnail for PISCO Filipino hospitality staffing, Spain UK healthcare`
- Infographic: `Clean infographic about Filipino BPO staff placement process`

### ProfileStack
- LinkedIn: `Modern tech thumbnail for LinkedIn profile rental marketplace startup`
- Ad: `LinkedIn ad creative for ProfileStack, professional purple blue theme`
