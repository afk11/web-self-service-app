FROM zfschuindt/node_and_ruby:node-9.9.0_ruby-2.4.0 as builder

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY package.json /usr/src/app/package.json

RUN npm install -g bower
RUN npm install -g gulp
COPY . /usr/src/app
RUN bower --allow-root install
RUN npm install
RUN gem install sass
RUN gulp build

FROM nginx:1.19.3
COPY --from=builder /usr/src/app/dist/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

