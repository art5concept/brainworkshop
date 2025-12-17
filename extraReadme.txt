Instructions for Linux
Brain Workshop has a few dependencies on Linux.

First, get OpenGL working. Brain Workshop uses OpenGL as a backend for drawing its graphics. Hardware acceleration is strongly recommended, but if it's not available or easy to set up, the Mesa software renderer also works.

Python: Most distributions come with Python preinstalled. Open a terminal and type python to ensure you have Python 2.5 or higher. Python 2.4 will also suffice as long as python-ctypes is installed.

If you would like music support (recommended), download and install AVBin by following these steps:

Download one of the following:
AVbin 7 installer for 32-bit Linux
AVbin 7 installer for 64-bit Linux
Open a terminal and change the directory to the download destination.
Type tar zxvf avbin-linux-x86-32-7.tar.gz to untar the files. (This example uses the 32-bit version)
Enter the newly created directory by typing: cd avbin-linux-x86-32-7
Install AVBin by typing sudo ./install.sh and entering your password.
Finally, download brainworkshop-4.8.1.zip.

Extract the files in the zip file to your hard drive. Important: The program will not work properly if you try to run it from within the zip file.

Open a terminal, enter the brainworkshop directory and type python brainworkshop.pyw to launch Brain Workshop. You may also enable execute permissions on brainworkshop.pyw if you'd like to launch it by double-clicking.

Begin increasing your working memory and fluid intelligence! Get started by reading the Tutorial.
Note: Many users have reported problems with sound on Ubuntu. This is likely due to the broken implementation of pulseaudio in all versions since 8.10. If you're having problems with sound, there are a few things you can try. First, you can try installing the python-openal package to use the OpenAL sound interface. If that doesn't work, you can try some of the fixes described in the page linked above. Failing that, you can always do sudo apt-get remove pulseadio libpulse0, and either use plain ALSA or install ESD in its place. If one of these fixes or something else works for you, please let us know about it so we can recommend it to other Ubuntu users. If you have sound problems on a different distribution, we'd like to hear about it.

Problems? Questions? Please contact me with details of the issue you are encountering.	


how create avbin in linux

Tested on a default install of Ubuntu 12.04 LTS (both 32- and 64-bit installs).

Install yasm: sudo apt-get install yasm
Install libbz2-dev: sudo apt-get install libbz2-dev
(If you want to make the binary installer) Install makeself: sudo apt-get install makeself
Run ./build.sh [desired options and targets]



que dice build.sh

#!/bin/bash
#
# build.sh
# Copyright 2007 Alex Holkner
# Copyright 2011-2013 AVbin Team
#
# This file is part of AVbin.
#
# AVbin is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 3 of
# the License, or (at your option) any later version.
#
# AVbin is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this program.  If not, see
# <http://www.gnu.org/licenses/>.

# Either "libav" or "ffmpeg"
BACKEND=libav

# Directory holding backend source code.
BACKEND_DIR=$BACKEND

# Make sure the git submodule is initiated and updated (if blank)
if ! ls $BACKEND_DIR/Makefile >/dev/null 2> /dev/null ; then
    git submodule init --quiet
    git submodule update
fi


AVBIN_VERSION=`cat VERSION`
AVBIN_PRERELEASE=`cat PRERELEASE 2>/dev/null`
AVBIN_VERSION_STRING="\"$AVBIN_VERSION$AVBIN_PRERELEASE\""
AVBIN_BUILD_DATE="\"`date +\"%Y-%m-%d %H:%M:%S %z\"`\""
AVBIN_REPO="\"`git remote show -n origin | grep Fetch | cut -b 14-`\""
AVBIN_COMMIT="\"`git rev-parse HEAD`\""

# Backend information
AVBIN_BACKEND="\"$BACKEND\""
pushd $BACKEND_DIR > /dev/null
AVBIN_BACKEND_VERSION_STRING="\"`git describe --abbrev=0 --tags`\""
if [ $AVBIN_BACKEND_VERSION_STRING == "\"v0.8\"" ] ; then
    TRUNK_DATE=`git log -1 --pretty=format:%cd`
    AVBIN_BACKEND_VERSION_STRING="\"trunk ($TRUNK_DATE)\""
fi
AVBIN_BACKEND_REPO="\"`git remote show -n origin | grep Fetch | cut -b 14-`\""
AVBIN_BACKEND_COMMIT="\"`git rev-parse HEAD`\""
popd > /dev/null

fail() {
    echo "AVbin: Fatal error: $1"
    exit 1
}

clean_backend() {
    pushd $BACKEND_DIR > /dev/null
    echo -n "Cleaning up..."
    make clean 2> /dev/null
    make distclean 2> /dev/null
    echo "done"
    find . -name '*.d' -exec rm -f '{}' ';'
    find . -name '*.pc' -exec rm -f '{}' ';'
    rm -f config.log config.err config.h config.mak .config .version
    popd > /dev/null
}

build_backend() {
    config=`pwd`/$PLATFORM.configure
    common=`pwd`/common.configure

    if [ ! $REBUILD ]; then
        clean_backend
    fi

    pushd $BACKEND_DIR > /dev/null

    # If we're not rebuilding, then we need to configure Backend
    if [ ! $REBUILD ]; then
        case $OSX_VERSION in
            "10.6") SDKPATH="\/Developer\/SDKs\/MacOSX10.6.sdk" ;;
            "10.7") SDKPATH="\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/MacOSX.platform\/Developer\/SDKs\/MacOSX10.6.sdk" ;;
            *)      SDKPATH="" ;;
        esac

        cat $config $common | egrep -v '^#' | sed s/%%SDKPATH%%/$SDKPATH/g | xargs ./configure || fail "Failed configuring backend."
    fi

    # Remove -Werror options from config.mak that break builds on some platforms
    cat config.mak | sed -e s/-Werror=implicit-function-declaration//g | sed -e s/-Werror=missing-prototypes//g > config.mak2
    mv config.mak2 config.mak

    # Actually build Backend
    make $FAST || fail "Failed to build backend."
    popd
}

build_avbin() {
    # For avbin.c ...
    export AVBIN_VERSION
    export AVBIN_VERSION_STRING
    export AVBIN_BUILD_DATE
    export AVBIN_REPO
    export AVBIN_COMMIT
    export AVBIN_BACKEND
    export AVBIN_BACKEND_VERSION_STRING
    export AVBIN_BACKEND_REPO
    export AVBIN_BACKEND_COMMIT

    # For the Makefile ...
    export PLATFORM
    export BACKEND_DIR

    if [ ! $REBUILD ]; then
        make clean
    fi

    make || fail "Failed to build AVbin."
}

build_macosx_universal() {
    if [ ! -e dist/macosx-x86-32/libavbin.$AVBIN_VERSION.dylib ]; then
        PLATFORM=macosx-x86-32
        build_backend
        build_avbin
    fi

    if [ ! -e dist/macosx-x86-64/libavbin.$AVBIN_VERSION.dylib ]; then
        PLATFORM=macosx-x86-64
        build_backend
        build_avbin
    fi

    mkdir -p dist/macosx-universal
    lipo -create \
        -output dist/macosx-universal/libavbin.$AVBIN_VERSION.dylib \
        dist/macosx-x86-32/libavbin.$AVBIN_VERSION.dylib \
        dist/macosx-x86-64/libavbin.$AVBIN_VERSION.dylib || fail "Failed to create universal shared library."
}

die_usage() {
    echo "Usage: ./build.sh [options] <platform> [<platform> [<platform> ...]]"
    echo
    echo "Options"
    echo "  --clean     Don't build, just clean up all generated files and directories."
    echo "  --fast      Use 'make -j9' when compiling"
    echo "  --help      Display this help text."
    echo "  --rebuild   Don't reconfigure, just run make again."
    echo
    echo "Supported platforms:"
    echo "  linux-x86-32"
    echo "  linux-x86-64"
    echo "  macosx-x86-32"
    echo "  macosx-x86-64"
    echo "  macosx-universal (builds all supported Mac OS X architectures into one library)"
    echo "  win32"
    echo "  win64"
    exit 1
}

for arg in $* ; do
    case $arg in
        "--fast")
            FAST="-j9" ;;
        "--help")
            die_usage ;;
        "--rebuild")
            REBUILD=1;;
        "--clean")
            clean_backend
            rm -rf dist
            rm -rf build
            rm -f example/avbin_dump
            rm -f example/minimal
            exit
            ;;
        *)
            if [ "$platforms" == "" ]; then
                platforms=$arg
            else
                platforms="$platforms $arg"
            fi
            ;;
    esac
done;

if [ "$platforms" == "" ]; then
    die_usage
fi

for PLATFORM in $platforms; do
    case $PLATFORM in
        "macosx-universal")
            OSX_VERSION=`/usr/bin/sw_vers -productVersion | cut -b 1-4`
            build_macosx_universal
            ;;
        "macosx-x86-32" | "macosx-x86-64")
            OSX_VERSION=`/usr/bin/sw_vers -productVersion | cut -b 1-4`
            build_backend
            build_avbin
            ;;
        "linux-x86-32" | "linux-x86-64" | "win32" | "win64")
            build_backend
            build_avbin
            ;;
        *)
            echo "Unrecognized platform: $PLATFORM.  Try ./build.sh --help" && exit 3
            ;;
    esac
done

echo "Build successful."





Brain Workshop: a Dual N-Back game in Python

Thank you for downloading Brain Workshop.
Please visit the Brain Workshop web site for help & instructions!

From the main screen, press W to open the web site.
Pressing H will open the Help & Tutorial page.

Or visit:
   http://brainworkshop.sourceforge.net

Configuration options are available in the file 'config.ini'
in the data folder. This file is created the when the program is
first launched. Windows users can access this file via the
'Configuration' item in the Brain Workshop group in the Start Menu.
Mac OS X users will need to right-click on the brainworkshop icon,
select "Show Package Contents", and browse to Contents/MacOS/data/.

Let us know if you have any comments or suggestions:

   plhosk@gmail.com
   jtoomim@jtoomim.org

Enjoy!

----------------------------------------------------------------------
*** NOTE TO LINUX AND SOURCE-CODE USERS: ***

Python 2.5 or later is required to run Brain Workshop on Linux. Python 2.4 
may also work as long as the python-ctypes package is installed.
[Note: Windows versions and Mac OS X .app bundled versions of Brain 
Workshop have python included.]

The latest version of python can be downloaded here:
      http://www.python.org/download/releases/

Music support requires AVBin (highly recommended!)
AVBin is included in binary distributions of Brain Workshop, but source
code users will want to download AVBin here:
      http://code.google.com/p/avbin/

Detailed instructions and links for Mac OS X, Linux and win32 source
installation are available on the Brain Workshop web site:

    http://brainworkshop.sourceforge.net

----------------------------------------------------------------------
Change Log:

4.8.1:
* Bugfix release.  Text shows up properly on Menu screens with
   BLACK_BACKGROUND=True.  Bug in graphing code fixed which caused some
   stats.txt files to not be graphable.  Option added to remove post-
   session feedback (requested by a researcher).  Daily session counter
   fixed.  Trials per session at startup fixed.

4.8:
* Changed config.ini file format.  Existing config.ini files will be
   renamed and replaced.  Users will have to migrate their 
   customizations manually.
* Added Multi-stim modes, whereby objects appear in two to four places
   in the 3x3 grid at the same time.  Objects can be differentiated 
   either by image or by color.
* Added Crab modes.  In crab modes, you have to reverse every N stimuli
   when matching, so that in 3-back, if the stimuli you saw were the
   first line below, then you would be matching them against the 
   second line, like thus:
        ABCDEFGHIJKLMNO
        ---CBAFEDIHGLKJ
* Full support for multiple users and/or profiles.  This lets you 
   easily keep separate statistics for different settings (for example,
   with different timings or with JAEGGI_SCORING in the config file) or
   for different users.
* Added an "interference" setting, whereby a certain percentage of the
   time Brain Workshop will generate trials designed to be particularly
   tricky, such as by making the current stimulus match the stimulus
   (n-1), (n+1), or (2n) trials ago, or (in multi-stim mode) by 
   swapping the positions of the stimuli (n) trials ago.
* New mode-, sound-, and user-selection screens.   
* Changed how often matches are generated for modes other than Dual
   N-back.
* Made Brain Workshop ask for donations, by default every 100 sessions.
   You should do as the program asks.  (This behavior can be
   changed in the config.ini file.)
* Trial-by-trial session data are now recorded to disk in Python's
   pickle format in the USERNAME-sessions.dat files.
* Changed how scores are calculated in graphing; the percentage of 
   items correct now affects the exact score in addition to the
   N-back level.
* All of the music files and some of the other media files have been 
   removed for copyright reasons and replaced with free alternatives.

4.7:
* Added Dual Audio n-back modes. Go to the Sound Selection screen to
   choose the sound set and channel (left, right, center) for each
   sound stimulus.
* Number of trials per session now increases automatically with higher
   n-back levels. The calculation can be adjusted from the config file.
* Timing resolution has been increased to 0.1 seconds, with a maximum
   speed of 0.3 seconds per trial. 
* Toggling Manual Mode no longer reverts to default settings.
* Title screen graphic is now colored inversely when a black background is
   selected.
* Stats file may be specified on the command line with --statsfile,
   complementing the --configfile command line parameter.
* Comments may be added to the stats file on separate lines beginning
   with the # character.

4.5:
* First release with Quad N-Back and other new modes
* Includes various other improvements.

4.41:
* The size of the field with the FIELD_EXPAND option was decreased slightly.

4.4:
* Novice Mode was renamed to Jaeggi Mode.
* Jaeggi Mode will activate certain options to emulate the appearance
   of the software used in the original study. Two configuration options
   were added to control this behavior.
   [Note: to see the new config options, delete your current config
    file and relaunch Brain Workshop to generate a fresh config.]
* The data and res directories can now be specified on the command line
   using the --datadir and --resdir parameters
   (contributed by Timo Juhani Lindfors <timo.lindfors@iki.fi>).
* The daily rollover hour for stats can now be specified in the config file.
* A bug was fixed where certain trials would not show up in the list
   if the program was launched between midnight and 4 AM.
* A setting to skip the title screen was added to the config file.
* The grid lines and crosshairs can be toggled in the config file.
* A setting was added to select rounded or sharp corners for the
   solid-color squares.
* A setting was added to expand the size of the field to fill the screen.
* Arithmetic Mode: The acceptable decimal answers can be set in the
   config file.
* Three new music clips were added.
* The Clear Stats key (Control-C) is working again.

4.3:
* Variable n-back levels can be used with any game mode by pressing V
   in the Choose Game Mode screen.
* Sounds for the auditory n-back task can be selected by pressing S.
* Letter N-Back renamed to Combination N-Back.
* New Morse Code sounds can be used with any n-back mode.
   For the ultimate challenge try using Morse Code with Dual, Tri or
   Quad Combination N-Back. Press J to open a Morse Code reference page.
* Average n-back indicator will only count sessions specific to the
   current game mode.
* Progress graphs now start from 1.0 on the vertical axis to give a
   better overall picture.
* The cutoff for daily averages is is now 4:00 AM instead of midnight.
* Music and applause is stopped when entering the progress graph to
   avoid sound skipping. (The sound may not stop in Linux due to
   driver limitations.)
* Config file changes: The starting N-Back mode and game speed is
   now separately adjustable for each game mode, and some colors
   can be customized. Variable N-Back can also be set as default.
   [Note: to see the new config options, delete your current config
   file and relaunch Brain Workshop to generate a fresh config.]

4.22:
* There's a new title screen.
* Launching in Novice Mode will no longer cause a crash.
* Progress graph: date axis will no longer skip days.
* Progress graph: data points are now indicated with a dot.
* Num pad should now work properly with Arithmetic N-Back modes.
* Difficulty of Dual Variable N-Back has been increased slightly.

4.2:
* Added new mode to stretch working memory: Dual Variable N-Back.
   The n-back level is displayed in the center and changes
   randomly every 3 seconds.
* Added single-task n-back modes: Position N-Back and Audio N-Back.
* Default config file is no longer packaged with the download
   so upgrading to this version won't overwrite existing
   configuration settings. The config file config.ini will be
   created if necessary when BW is launched for the first time.
* OpenAL is now the default sound driver in Linux if available.
   If you're having sound problems, it may help to install the
   python-openal package.
* There's no longer any need to install pyglet on Mac OS X or Linux.
   It's now included with the source distribution.

4.12:
* Fixed level increase threshold in Novice mode
* Novice mode now generates 4 visual matches, 4 audio matches
   and 2 simultaneous matches, matching the formula used in the
   original study.

4.11:
* Fixed level decrease threshold in Novice mode
* Added a configuration option to use the pre-4.1 flat squares
* Two changes to Novice Mode to eliminate the last of the differences
  compared to the original study protocol:
     1. Exactly 6 position and 6 audio matches are now generated each
           session
     2. The score for the session is set as the lowest of the two
           individual modality scores (visual & audio).

4.1:
* The squares in Dual & Triple N-Back have a new look.
* Individual scores for each input category (position, sound, etc)
   are shown in the graph screen.
* The number of sessions below 50% required to trigger a
   level decrease has been changed from 1 to 3.
* New piano sounds are available in the config file to test your
   tonal memory. 
* Pressing the ESC key during a session will return you to the
   main screen instead of quitting the program.

4.04:
- Added the division operation to the Arithmetic N-Back modes.
   Use the period key '.' to insert a decimal point.
   Each of the operations (add, subtract, multiply, divide)
   can be turned off or on in any combination in the config file.
- Fixed a bug where if you had just advanced to a new level and
   quit BW, the next time you restarted you would be back at
   the previous level.
- Added config option to play music in Manual mode.

4.03:
- Added new number sounds (0-13). Either the letters or the numbers
   will be chosen randomly at the start of each session.
- The female voice sounds are now selected by default.
- Added two new game modes, Dual Arithmetic N-Back and Triple
   Arithmetic N-Back. Press N from the main screen to access
   the extra game modes.

4.02:
- Fixed sound driver selection in Linux.
- A few minor changes related to Arithmetic N-Back mode.

4.0:
- New game mode: Arithmetic N-Back (see tutorial for details)
- Optional Novice mode (aka BT mode) emulates the original study
  protocol.
- New NATO Phonetic Alphabet sounds (alpha, bravo, charlie, etc).
   The old sounds are still available as an option.
- Keep track of your daily progress with the new graphing feature.
- Export your history of daily n-back averages to a text file
  for easy pasting into a spreadsheet.
- Adaptive level-changing model ensures you're always playing
   at the right level.
- Keyboard keys can now be redefined.
- Feedback for missed cues is displayed.
- Feedback can be turned off in the config file if desired.
- Text can be hidden during gameplay to reduce distractions.
- Optional full-screen mode for a larger, distraction-free
   playing field.
- Optional black background reduces eye strain.
- Easy config file provides access to configuration options.

3.1:
- Enabled high performance VBO (vertex buffer object). If you get a
   MissingFunctionException, use the --novbo command line parameter
   to launch Brain Workshop.
- Changed preferred sound driver to ALSA on Linux.
- Converted letter sounds to 44.1 KHz to alleviate crackling problem
   on certain sound hardware.

3.01:
- When first loading, if the last session completed was in Standard
   mode, Brain Workshop will start at the same n-back level.
- Only today's sessions are loaded in the history chart.

3.0:
- Three consecutive scores of >=80% are now required to advance levels,
   as indicated by the grey/green squares in the top left corner.
   A grey square will turn green if a >=80% score is achieved and a
   green square (if any) will turn grey if the score is below 80%.
   Once both squares are green and another 80% is achieved, the level
   increases. A 100% score will cause an instant advancing.
- The entries on the session history chart will turn green if
   the session is >= 80%. The chart now displays in a variable-width
   font.
- Added the time.sleep() workaround to reduce CPU usage on OS X.
   Disabled Vsync to eliminate an error message on certain machines.
- New columns have been added to the stats.txt file, including
   individual percentage scores for the six input types. Please see
   Readme-stats.txt in the data directory for details.

2.7:
- Added a new column in the stats file:
	0 = Standard mode, 1 = Training mode
- one new music clip added
- Added an encouraging message if you get below 40%

2.64:
- Lowered level advance threshold to 80%.
- Added a workaround for pyglet.gl.lib.MissingFunctionException
  which occurs on certain video cards.

2.63:
- Fixed a bug causing 100% CPU utilization.
- Fixed a crash caused by the music clip feature.
- Reduced startup time and memory footprint.

2.62:
- Contribution to the n-back average is now calculated like so:
	(nback - 1) + percentage / 100
   This means the average n-back level for a single 4-back session
   with a score of 50 percent will now be 3.5 instead of 2.

- Fixed a bug in the input feedback that would show correct responses
   as incorrect (this did not affect stats). 
- Added more music clips and adjusted the length and volumes of the
   existing ones.

2.6:
- Added color feedback on input. The input labels ('A: position' etc)
   will turn red for incorrect, green for correct and blue if
   there haven't been enough trials yet.

2.5:
- Fixed bug where a bogus stats entry would be created under
   certain conditions when switching from Standard to Training mode.
- Removed the need for Tkinter on Linux and OS X.

2.4:
Added music clips which play when certain scores are achieved.

2.3:
- Added a Sessions Today indicator which shows the total number of
   sessions completed this calendar day. Useful for tracking progress
   on your 20 session per day training quota.
- Added possibility of different stats files on the command line.
     Give each person in your family a separate desktop icon!
        example: brainworkshop.exe --statsfile fred.txt
                 brainworkshop.exe --statsfile mary.txt
- Brain Workshop now starts in Standard mode. This enforces
  certain settings for number of trials and time per trial,
  making it easier to compare scores. Currently these are
  specified as follows:
	All modes are 20 trials per session.
            Dual N-Back: starts with 2-back, 3 seconds
          Triple N-Back: starts with 2-back, 3 seconds
     Dual Letter N-Back: starts with 1-back, 3 seconds
      Tri Letter N-Back: starts with 1-back, 4 seconds
     Quad Letter N-Back: starts with 1-back, 4 seconds
- Fixed a bug in the average n-back calculation
- Changed stats file format from tab-separated to comma-separated.
   Old stats files will still load successfully.

2.2:
   - Session stats are now output to the file data\stats.txt
   - Previous stats are loaded upon launch.
   - Added an option to clear stats (this does not affect stats.txt)
   - Average N-Back level is calculated for the last 20 sessions.
        The contribution of a particular session is calculated:
           Contribution = (N-back level) * (Percentage score) / 100
        Average is calculated as:
           Average = (sum of contributions) / (number of sessions)

2.1:
   - Added three new challenging game modes:
      Dual Letter N-Back, Tri Letter N-Back, Quad Letter N-Back
   - Adjusted level advance threshold from 100% to 90%
   - Adjusted "applause" threshold from 80% to 70%

2.0:
   - Applause sound now plays when a score of 80% is achieved
   - Version check is now performed on launch
   - Added a workaround for the pyglet.gl.ContextException error
      which occurs on certain video cards
   - Added a more descriptive error message in case an old version
      of pyglet is installed
   - Fixed cosmetic issue with the session history label on Linux


