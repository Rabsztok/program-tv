program-tv [![Code Climate](https://codeclimate.com/repos/52446f19c7f3a33bfd000799/badges/c100ff88976f9fa85940/gpa.png)](https://codeclimate.com/repos/52446f19c7f3a33bfd000799/feed) [![Dependency Status](https://gemnasium.com/Rabsztok/program-tv.png)](https://gemnasium.com/Rabsztok/program-tv) [![Gem Version](https://badge.fury.io/rb/program-tv.png)](http://badge.fury.io/rb/program-tv)
===============

Downloads TV channel schedule in XML format

Installation
============

    $ gem install program-tv

Usage
=====

When gem is installed, just use program-tv command e.g.:

    $ program-tv

Or if you want to configure script, use -d command to specify directory with your epg files, and -c command to specify your own channel list, you can see channels.yml for example.

    $ program-tv > program.xml -d /path/to/epg -c /path/to/channel-list.yml

Contact
=======

If you have any ideas, feedback, requests or bug reports, you can reach me at
[rabsztok@gmail.com](mailto:rabsztok@gmail.com).
