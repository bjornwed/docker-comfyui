# DreamshaperXL sfwLightningDPMSDE
Lightning version targets 3-6 sampling steps at CFG scale 2 and should also work only with DPM++ SDE Karras. Avoid going too far above 1024 in either direction for the 1st step.

# Dreamshaper_8LCM
- Clipskip 2
- 5-15 steps
- around 2 CFG
- LCM sampler

# Flux Controlnet Union Pro
- recommended controlnet_conditioning_scale: 0.3-0.8
- Can be used with regular Controlnet custom nodes
- put model into regular controlnet path, eg. ..models\controlnet\flux