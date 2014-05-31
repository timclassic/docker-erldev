.PHONY: all build image ssh-id

define sshid
echo "Looking for RSA key" \
    && test -f ~/.ssh/id_rsa \
    && cp -p ~/.ssh/id_rsa sshid \
    || ( echo "RSA key not found, trying DSA" \
         && cp -p ~/.ssh/id_dsa sshid )
endef


all: image

image:
	$(sshid)
	docker build -t "stoo/erlang-dev:0.1.0" .
	rm -f sshid

latest: image
	$(sshid)
	docker build -t "stoo/erlang-dev:latest" .
	rm -f sshid
