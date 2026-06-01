# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.4-base

# install custom nodes into comfyui
RUN comfy node install --exit-on-fail comfyui-impact-pack@8.28.2 --mode remote || (echo "WARN: comfyui-impact-pack@8.28.2 unavailable in registry, falling back to latest" >&2 && comfy node install --exit-on-fail comfyui-impact-pack --mode remote)
RUN comfy node install --exit-on-fail comfyui-custom-scripts@1.2.5 || (echo "WARN: comfyui-custom-scripts@1.2.5 unavailable in registry, falling back to latest" >&2 && comfy node install --exit-on-fail comfyui-custom-scripts)
RUN comfy node install --exit-on-fail comfyui-videohelpersuite@1.7.9 || (echo "WARN: comfyui-videohelpersuite@1.7.9 unavailable in registry, falling back to latest" >&2 && comfy node install --exit-on-fail comfyui-videohelpersuite)
RUN comfy node install --exit-on-fail rgthree-comfy@1.0.2604070017 || (echo "WARN: rgthree-comfy@1.0.2604070017 unavailable in registry, falling back to latest" >&2 && comfy node install --exit-on-fail rgthree-comfy)
RUN git clone https://github.com/kijai/ComfyUI-KJNodes /comfyui/custom_nodes/ComfyUI-KJNodes && cd /comfyui/custom_nodes/ComfyUI-KJNodes && (git checkout 5dcda71011870278c35d92ff77a677ed2e538f2d 2>/dev/null || (git fetch origin 5dcda71011870278c35d92ff77a677ed2e538f2d --depth=1 && git checkout 5dcda71011870278c35d92ff77a677ed2e538f2d) || echo "WARN: commit 5dcda71011870278c35d92ff77a677ed2e538f2d unreachable in https://github.com/kijai/ComfyUI-KJNodes, falling back to default branch HEAD")

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/

# user-provided inputs override the auto-generated placeholders above.
RUN wget --progress=dot:giga -O '/comfyui/input/example.png' "https://cool-anteater-319.convex.cloud/api/storage/bc3dc194-5208-417d-a026-7e87959eabd1"
