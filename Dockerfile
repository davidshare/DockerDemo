# speficy the version of node to bigip_software_install
FROM node:10-alpine as builder

# specify the project directory
WORKDIR /usr/selene

# move the package.json to the root directory
COPY package*.json ./

# install npm modules
RUN npm install

# copy the content of the local project directory to the root directory of the project in the container
COPY . .

# run npm build
RUN npm run build

# FROM nginx:1.15-alpine
FROM node:10-alpine

# specify the project directory
WORKDIR /usr/selene

# copy the build files and the package.json file to the root directory of the project in the container
COPY --from=builder /usr/selene/package*.json /usr/selene/
COPY --from=builder /usr/selene/node_modules /usr/selene/node_modules
COPY --from=builder /usr/selene/dist /usr/selene/dist
COPY --from=builder /usr/selene/server.js /usr/selene/

# expose port 8080 for the project
EXPOSE 8080

# start the application
CMD ["npm", "run", "serve"]