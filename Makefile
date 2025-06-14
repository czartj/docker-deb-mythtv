default: docker_build

docker_build:
#	@docker build -t podman build -t localhost/czartj/docker-deb-mythtv:latest --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg BUILD_DATE=`date -u +"%Y-%m-%dTH:%M:%SZ"` .
	@podman build -t czartj/docker-deb-mythtv:latest --build-arg BUILD_DATE=`date -u +"%Y-%m-%dTH:%M:%SZ"` .
