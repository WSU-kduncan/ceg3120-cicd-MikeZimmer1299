FROM node:18-bullseye

WORKDIR /tempApp

COPY angular-site/wsu-hw-ng-main/. /tempApp

RUN npm install
RUN npm install -g @angular/cli

EXPOSE 5002

# Do I even need CMD for a web page? I don't think so?
# Yes, I do need this. It's very important, as it binds the server
CMD ng serve --host 0.0.0.0
