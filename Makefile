TARGET=atlocs_web
VERSION=prod-65

prodaccess:
	gcloud docker -a -s gcr.io

docker:
	docker build -t $(TARGET):$(VERSION) .
	docker tag $(TARGET):$(VERSION) $(TARGET):latest

push:
	docker tag $(TARGET):latest $(TARGET):$(VERSION)
	docker tag $(TARGET):$(VERSION) gcr.io/master-tuner-150318/$(TARGET):$(VERSION)
	docker push gcr.io/master-tuner-150318/$(TARGET):$(VERSION)
