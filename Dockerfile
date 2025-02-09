FROM node:lts-alpine3.14 as builder
WORKDIR /front
ARG HREF
COPY . /front
RUN npm install -y
RUN npm install -g @angular/cli -y
RUN ng build --prod

FROM nginx:1.17.6-alpine
RUN rm -r /usr/share/nginx/html/
COPY --from="builder" /front/dist/fastest-typer-front/ /usr/share/nginx/html/
COPY --from="builder" /front/script.sh /
CMD ["/bin/sh",  "-c",  "envsubst< /script.sh > /script-template.sh && sh /script-template.sh && envsubst < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js && exec nginx -g 'daemon off;'"]
