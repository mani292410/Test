# FROM node
FROM sbo-cicd-docker-release-local.usw1.packages.broadcom.com/broadcom-custom-images/centos/8/npm:latest

WORKDIR /backend

RUN npm install pm2 -g

COPY .npmrc .

COPY package.json .

RUN npm set progress=false && npm install

COPY . .

EXPOSE 8080

#RUN npm run migrate:linux:dev:db1

CMD ["npm", "run", "start:linux:docker:dev"]
