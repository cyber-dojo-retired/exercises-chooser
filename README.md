
[![Build Status](https://travis-ci.org/cyber-dojo/start-points-exercises.svg?branch=master)](https://travis-ci.org/cyber-dojo/start-points-exercises)
[![CircleCI](https://circleci.com/gh/cyber-dojo/start-points-exercises.svg?style=svg)](https://circleci.com/gh/cyber-dojo/start-points-exercises)

<img src="https://raw.githubusercontent.com/cyber-dojo/nginx/master/images/home_page_logo.png" alt="cyber-dojo yin/yang logo" width="50px" height="50px"/>

The git repo for [cyber-dojo's](https://github.com/cyber-dojo/web)
default exercises choices.

You can specify and use an alternative exercises start-point.

Assuming the files in the specified repo have the
[correct format](http://blog.cyber-dojo.org/2016/08/creating-your-own-start-points.html):

```
$ ./cyber-dojo start-point create --help
$ ./cyber-dojo start-point create mike --git=https://github.com/mike/start-points-exercises.git
$ ./cyber-dojo up --exercises=mike
```
