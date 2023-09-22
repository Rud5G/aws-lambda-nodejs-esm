FROM node:18-buster as build-image

# Include global arg in this stage of the build
# Install build dependencies
RUN apt-get update && \
    apt-get install -y \
    g++ \
    make \
    cmake \
    unzip \
    libcurl4-openssl-dev

# Copy function code
RUN mkdir -p /var/task

WORKDIR /var/task

COPY ./lambda .

# Install Node.js dependencies
RUN npm install

RUN ls -ahls .

# Install the runtime interface client
RUN npm install aws-lambda-ric


# Grab a fresh slim copy of the image to reduce the final size
#FROM node:18-buster-slim
FROM public.ecr.aws/lambda/nodejs:18

# Required for Node runtimes which use npm@8.6.0+ because
# by default npm writes logs under /home/.npm and Lambda fs is read-only
ENV NPM_CONFIG_CACHE=/tmp/.npm

# Set working directory to function root directory
WORKDIR /var/task

# Copy in the built dependencies
COPY --from=build-image /var/task /var/task

# Set runtime interface client as default command for the container runtime
#ENTRYPOINT ["npx", "aws-lambda-ric"]
# Pass the name of the function handler as an argument to the runtime
CMD ["index.handler"]