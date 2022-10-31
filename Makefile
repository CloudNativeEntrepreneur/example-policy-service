LOCAL_DEV_CLUSTER ?= kind-local-dev-cluster
NOW := $(shell date +%m_%d_%Y_%H_%M)
SERVICE_NAME := example-policy-service

onboard: install

install:
	npm ci

dev:
	npm run dev

open:
	code .
