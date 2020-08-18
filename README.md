# ExtractPowerPointFromVideo
Extracts a PowerPoint (or slideshow) from a video. Useful for university lectures.

## Requirements

- ffmpeg version 4.3.0 or later

- youtube-dl (optional)

## How to use

Consider this YouTube video: https://www.youtube.com/watch?v=oRnl-6MBp80. It has a PowerPoint, and those slides are shown on screen at various times in the video. To extract these frames, download the video using youtube-dl `youtube-dl https://www.youtube.com/watch?v=oRnl-6MBp80` then run the script against this downloaded video file.

Using the default settings (95% percentile, 5 fps) I get a collection of images in the `images` folder which are slides from the on-screen PowerPoint. It's not perfect however, and occasionally I get some images of the presenter.


## How does it work?

It uses ffmpeg's `scenedetect` API which computes the noise between two frames. If the noise is within a certain threshold (i.e. the frame hasn't changed much), then it could be a PowerPoint slide, because it has been on screen for a while. The default settings require that the noise ratio doesn't exceed a certain threshold for at least 1000ms.
