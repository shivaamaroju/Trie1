FROM nginx:alpine

# Use the leading forward slash /
COPY . /usr/share/nginx/html

EXPOSE 80
