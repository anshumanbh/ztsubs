FROM alpine:latest

RUN apk add --no-cache --upgrade bind-tools python coreutils
RUN mkdir app
WORKDIR app
ADD run.sh .

ENTRYPOINT [ "./run.sh" ]

