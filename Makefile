# Makefile for installing the ai extension

# Extension name
PGAI_EXTENSION := ai

# Find the PostgreSQL extension directory
PG_SHAREDIR := $(shell pg_config --sharedir)
EXTENSION_DIR := $(PG_SHAREDIR)/extension

# Files to be installed
SQL_FILES := $(wildcard $(PGAI_EXTENSION)--*.sql)
CONTROL_FILE := $(PGAI_EXTENSION).control

# Default target
default: help

# Install target
install: install_extension install_python_packages

# Install the extension files
install_extension:
	@cp $(SQL_FILES) $(EXTENSION_DIR)
	@cp $(CONTROL_FILE) $(EXTENSION_DIR)

# Install the required Python packages
install_python_packages:
	@pip3 install --break-system-packages -r requirements.txt

test:
	@./test.sh

vm_create:
	@./vm.sh

vm_start:
	@multipass start pgai

vm_stop:
	@multipass stop pgai

vm_delete:
	@multipass delete --purge pgai

vm_shell:
	@multipass shell pgai

docker_build:
	@docker build -t pgai .

docker_run:
	@docker run -d --name pgai -p 127.0.0.1:9876:5432 -e POSTGRES_HOST_AUTH_METHOD=trust --mount type=bind,src=$(shell pwd),dst=/pgai pgai

docker_stop:
	@docker stop pgai

docker_rm:
	@docker rm pgai

docker_shell:
	@docker exec -it -u root pgai /bin/bash

# Display help message with available targets
help:
	@echo "Available targets:"
	@echo "  install                  Install the pgai extension and Python dependencies"
	@echo "  install_extension        Install the pgai extension files"
	@echo "  install_python_packages  Install required Python packages"
	@echo "  test                     Runs the unit tests in the database"
	@echo "  vm_create                Create a virtual machine for development"
	@echo "  vm_start                 Starts the development virtual machine"
	@echo "  vm_stop                  Stops the development virtual machine"
	@echo "  vm_delete                Deletes the development virtual machine"
	@echo "  vm_shell                 Gets a shell inside the development virtual machine"
	@echo "  docker_build             Builds a Docker image for a development container"
	@echo "  docker_run               Runs a Docker container for development"
	@echo "  docker_stop              Stops the docker container"
	@echo "  docker_rm                Deletes the Docker container"
	@echo "  docker_shell             Gets a shell inside the development Docker container"

.PHONY: default install install_extension install_python_packages test vm_create vm_start vm_stop vm_delete vm_shell docker_build docker_run docker_delete docker_shell help
