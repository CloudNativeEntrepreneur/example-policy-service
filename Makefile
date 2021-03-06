LOCAL_DEV_CLUSTER ?= kind-local-dev-cluster
NOW := $(shell date +%m_%d_%Y_%H_%M)
SERVICE_NAME := example-policy-service

onboard: install deploy-to-local-cluster

build-new-local-image:
	kubectl ctx $(LOCAL_DEV_CLUSTER)
	docker build -t $(SERVICE_NAME) .
	docker tag $(SERVICE_NAME):latest dev.local/$(SERVICE_NAME):$(NOW)

load-local-image-to-kind:
	kubectl ctx $(LOCAL_DEV_CLUSTER)
	kind --name local-dev-cluster load docker-image dev.local/$(SERVICE_NAME):$(NOW)

deploy-to-local-cluster:
	kubectl ctx $(LOCAL_DEV_CLUSTER)
	helm template ./charts/$(SERVICE_NAME)/ \
		-f ./charts/$(SERVICE_NAME)/values.yaml \
		--set image.repository=dev.local/$(SERVICE_NAME),image.tag=$(NOW),knative.eventing.local=true,knative.eventing.subscriber=http://host.docker.internal:5020 \
		| kubectl apply -f -

delete-local-deployment:
	kubectl ctx $(LOCAL_DEV_CLUSTER)
	helm template ./charts/$(SERVICE_NAME)/ \
		-f ./charts/$(SERVICE_NAME)/values.yaml \
		--set image.repository=dev.local/$(SERVICE_NAME),image.tag=$(NOW) \
		| kubectl delete -f -

refresh-kind-image: build-new-local-image load-local-image-to-kind deploy-to-local-cluster
hard-refresh-kind-image: delete-local-deployment build-new-local-image load-local-image-to-kind deploy-to-local-cluster

localizer:
	localizer expose default/$(SERVICE_NAME) --map 80:5020

stop-localizer:
	localizer expose default/$(SERVICE_NAME) --stop

install:
	npm ci

dev:
	npm run dev

open:
	code .
