# Image-video-processing

### A1.m performs:
* Read a selected image
* Display the original image
* Display the grayscale image
* Compute histogram of the gray levels
* Gamma correction
* Negative transformation
* Ordered dithering


### A2.m performs:
* Read a selected scene image and a sprite image
* Create a new image which the sprite is merged into the scene
* Compress the merged image and save it as result.mrg. Compression includes:
    * Transform from RGB to YUV
    * 4:2:0 chroma subsampling
    * 2D DCT and IDCT transformation
    * Quantization


### A2Decoder.m performs:
* Read a *.mrg file
* The reverse process of compressing
* Display the image


### compress.m performs:
* Read a sequence of image and a video
* Merge images to video, compress and save it as data.mv. Video compressing includes:
    * Motion Estimation
    * I Frames Encoding
    * Errors Encoding


### player.m performs:
* read data.mv
* Decompress the video and display it. Decompressing includes:
