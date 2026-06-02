import os
import json

index = {
    "directories": [],
    "files": []
}

for root, dirs, files in os.walk("."):
    if ".git" in root:
        continue

    for d in dirs:
        index["directories"].append(os.path.join(root, d))

    for f in files:
        path = os.path.join(root, f)

        try:
            size = os.path.getsize(path)
        except:
            size = 0

        index["files"].append({
            "path": path,
            "size": size
        })

with open(".repo-index.json", "w") as outfile:
    json.dump(index, outfile, indent=2)

print("Created .repo-index.json")