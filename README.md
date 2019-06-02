
[![CircleCI](https://circleci.com/gh/cyber-dojo/exercises.svg?style=svg)](https://circleci.com/gh/cyber-dojo/exercises)

- The source for the [cyberdojo/exercises](https://hub.docker.com/r/cyberdojo/exercises/tags) Docker image.
- A docker-containerized stateless micro-service for [https://cyber-dojo.org](http://cyber-dojo.org).
- Serves the exercises choices when setting up a practice session.

```bash
#!/bin/bash
set -e
SCRIPT=cyber-dojo
GITHUB_ORG=https://raw.githubusercontent.com/cyber-dojo
curl -O --silent --fail "${GITHUB_ORG}/commander/master/${SCRIPT}"
chmod 700 ./${SCRIPT}

IMAGE_NAME=cyberdojo/exercises
GIT_REPO_URL=https://github.com/cyber-dojo/exercises.git

./${SCRIPT} start-point create \
   "${IMAGE_NAME}" \
    --exercises \
      "${GIT_REPO_URL}"        
```

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
