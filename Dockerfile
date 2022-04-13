# ---- Base Node ----
FROM node:16-alpine AS base
RUN apk add --no-cache nodejs-current 
# set working directory
WORKDIR  /usr/src/app
# copy project file
COPY package.json .

#
# ---- Dependencies ----
FROM base AS dependencies
# install node packages
RUN npm set progress=false && npm config set depth 0
RUN npm install --only=production 
# copy production node_modules aside
RUN cp -R node_modules prod_node_modules
# install ALL node_modules, including 'devDependencies'
RUN npm install
RUN cp -R node_modules dev_node_modules

FROM base AS dev
ENV NODE_ENV=development
RUN npm install -g nodemon && npm install
COPY --from=dependencies  /usr/src/app/dev_node_modules ./node_modules
COPY --chown=node:node . .

#
# ---- Release ----
FROM base AS release
# copy production node_modules
COPY --from=dependencies  /usr/src/app/prod_node_modules ./node_modules
# copy app sources
COPY --chown=node:node . .
# expose port and define CMD
EXPOSE 3000
CMD node app.js
