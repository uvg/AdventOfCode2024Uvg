# Specify the base image with a version tag
FROM intersystemsdc/iris-community:2023.1.4.580.0-zpm

RUN addgroup -S irisgrp || true \
    && adduser -S irisowner -G irisgrp || true

USER irisowner
# Set the working directory
WORKDIR /opt/irisapp

# Define build arguments with default values
ARG TESTS=0
ARG MODULE="aoc-2024-uvg"
# ARG NAMESPACE="IRISAPP"
ARG NAMESPACE="USER"

# Install and configure the application
RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
    iris session IRIS < iris.script && \
    ([ "$TESTS" -eq 0 ] || \
    iris session iris -U "$NAMESPACE" "##class(%ZPM.PackageManager).Shell(\"test $MODULE -v -only\",1,1)") && \
    iris stop IRIS quietly
