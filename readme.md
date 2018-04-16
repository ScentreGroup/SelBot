#Selbot

Selbot is an App Store preview/screenshot processing tool written in [Processing](http://www.processing.org).

Upon running the Processing script, you will be prompted for a directory to read from. example_content in this repository shows the directory structure with config and design resources.

Selbot works by layering a background image, screenshot, device frame and title text into a image sized to a specified output. Sizes and graphic positions for each device are set in `config.json` in their respective folders.

Upon a successful run, screenshots will be sorted by device in an `/output` folder within the selected folder.
