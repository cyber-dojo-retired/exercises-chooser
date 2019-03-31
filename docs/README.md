
<img src="https://raw.githubusercontent.com/cyber-dojo/nginx/master/images/home_page_logo.png" alt="cyber-dojo yin/yang logo" width="50px" height="50px"/>

Not live yet. Working towards making it live on https://beta.cyber-dojo.org

[![CircleCI](https://circleci.com/gh/cyber-dojo/exercises.svg?style=svg)](https://circleci.com/gh/cyber-dojo/exercises)

Specifies the start-points used to create the cyberdojo/exercises Docker image.

```bash
$ IMAGE_NAME=cyberdojo/exercises

$ ./cyber-dojo start-point create \
    ${IMAGE_NAME} \
      --exercises \
        https://github.com/cyber-dojo/exercises

$ ./cyber-dojo up \
    --exercises=${IMAGE_NAME}:latest
```

- - - -

* [Take me to cyber-dojo's home github repo](https://github.com/cyber-dojo/cyber-dojo).
* [Take me to https://cyber-dojo.org](https://cyber-dojo.org).

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
