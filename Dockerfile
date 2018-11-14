FROM php:7.2-cli
COPY ./website ./
WORKDIR ./website
CMD ["php", "index.php"]
