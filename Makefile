TARGET=atlocs_web
VERSION=prod-8

docker:
	docker build -t $(TARGET):$(VERSION) .
	docker tag -f $(TARGET):$(VERSION) $(TARGET):latest

push:
	docker tag -f $(TARGET):latest $(TARGET):$(VERSION)
	docker tag -f $(TARGET):$(VERSION) gcr.io/master-tuner-150318/$(TARGET):$(VERSION)
	docker push gcr.io/master-tuner-150318/$(TARGET):$(VERSION)
	
