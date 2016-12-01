TARGET=atlocs
VERSION=test-2

docker:
	docker build -t $(TARGET):$(VERSION) .
	docker tag $(TARGET):$(VERSION) $(TARGET):latest

push:
	docker tag $(TARGET):$(VERSION) gcr.io/cloud-mancutech/$(TARGET):$(VERSION)
	docker push gcr.io/cloud-mancutech/$(TARGET):$(VERSION)
	
