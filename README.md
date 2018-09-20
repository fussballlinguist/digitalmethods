# digitalmethods

This project comes up with some Perl scripts for tasks similar to those of the [Digital Methods Initiative](https://wiki.digitalmethods.net/Dmi/WinterSchool2019).

# Screencast Documentaries

**screencast_documentary.pl** is a script to scrape the URLs of all versions of Wikipedia pages (including user pages etc.) in order to to make automatized screenshots of a defined number of URLs (say the first 50 versions or the 50 most recent ones) and to generate a video from the pictures. Thus, the script automatically generates screencast documentaries as outlined by Richard Rogers in his article [Doing Web history with the Internet Archive: screencast documentaries](https://doi.org/10.1080/24701475.2017.1307542).

##Getting started

Before use, the following software/packages must be installed:

* [Selenium](https://www.seleniumhq.org/download/)
* [Selenium::Remote::Driver](https://metacpan.org/pod/Selenium::Remote::Driver)
* [ImageMagick](http://www.imagemagick.org/script/index.php) (for Mac: [ImageMagick](http://macappstore.org/imagemagick/))

To run the script, just define the URL of the Wikipedia Page and the target path. Then run the script from the command line by typing:

```perl /path/to/screencast_documentary.pl```

You will be asked the number of versions you want to make screenshots of and whether you want to generate a video automatically. The video format can be adjusted in the script (video subroutine).

The script was tested on Mac OS Sierra and Safari 12.0. For other systems you might change the browser in the script (screenshot subroutine). Note that then capturing the whole page and not only the visible part may not work.

## Use cases

Some examples you can see here or [here](https://twitter.com/fussballinguist/status/1042052859536310272).

## Authors

Simon Meier-Vieracker, Berlin (http://www.fussballlinguistik.de)

## License

This project is licensed under the GNU General Public License v2.0
