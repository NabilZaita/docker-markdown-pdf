FROM node:buster-slim
LABEL Author="Nanahira <nanahira@momobako.com>"

RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y \
        python3 build-essential google-chrome-stable fonts-ipafont-gothic fonts-wqy-microhei fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
        gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
        libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
        libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
        libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxtst6 \
        ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils \
        xvfb x11vnc x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic x11-apps \
      --no-install-recommends \
    && npm -g install pm2 \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY ./package*.json ./
RUN npm ci && \
    node node_modules/puppeteer/install.js
COPY . ./
RUN npm run build

ENV DISPLAY :99
CMD ["pm2-docker", "/usr/src/app/pm2-docker.json"]
