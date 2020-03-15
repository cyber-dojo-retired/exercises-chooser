FROM cyberdojo/sinatra-base
LABEL maintainer=jon@jaggersoft.com

COPY --chown=nobody:nogroup . /app

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}

ARG CYBER_DOJO_EXERCISES_CHOOSER_PORT
ENV PORT=${CYBER_DOJO_EXERCISES_CHOOSER_PORT}
EXPOSE ${PORT}

USER nobody
CMD [ "/app/up.sh" ]
