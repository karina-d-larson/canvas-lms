import os
import json

summaries = {}

for root, dirs, files in os.walk("."):
    if ".git" in root:
        continue

    summaries[root] = {
        "file_count": len(files),
        "subdirectory_count": len(dirs),
        "sample_files": files[:5]
    }

with open(".folder-summaries.json", "w") as outfile:
    json.dump(summaries, outfile, indent=2)

print("Created .folder-summaries.json")