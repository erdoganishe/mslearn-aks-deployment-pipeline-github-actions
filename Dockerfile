FROM nginx:1.18

# Install dependencies
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && apt-get update -y && apt-get install -y git curl nodejs && \
    curl -sL https://github.com/gohugoio/hugo/releases/download/v0.91.2/hugo_extended_0.91.2_Linux-64bit.tar.gz | tar -xz hugo && mv hugo /usr/bin && \
    npm i -g postcss-cli autoprefixer

# Clone the repository
RUN git clone https://github.com/MicrosoftDocs/mslearn-aks-deployment-pipeline-github-actions /contoso-website

# Set working directory
WORKDIR /contoso-website/src

# Update submodules
RUN git submodule update --init themes/introduction

# Build the Hugo site
RUN hugo

# Debugging: Check if the Hugo build was successful
RUN if [ -d "public" ]; then echo "Hugo build succeeded"; else echo "Hugo build failed"; exit 1; fi

# Move built files to NGINX html directory
RUN mv public/* /usr/share/nginx/html

EXPOSE 80