# speficy the version of node to bigip_software_install
FROM node:10

# specify the project directory
WORKDIR /usr/selene

# move the package.json to the root directory
COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8000

CMD ["npm", "start"]
