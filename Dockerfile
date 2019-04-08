# speficy the version of node to bigip_software_install
FROM node:10-alpine as builder

# specify the project directory
WORKDIR /usr/selene

# move the package.json to the root directory
COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# FROM nginx:1.15-alpine
FROM node:10-alpine

# specify the project directory
WORKDIR /usr/selene

COPY --from=builder /usr/selene/package*.json /usr/selene/

COPY --from=builder /usr/selene/node_modules /usr/selene/node_modules

COPY --from=builder /usr/selene/dist /usr/selene/dist

COPY --from=builder /usr/selene/server.js /usr/selene/

EXPOSE 8080

CMD ["npm", "run", "serve"]