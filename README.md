This docker images is base on alpine:3.10.1 and create a ssh console using google-authenticator as one time password login

Create .google_authenticator by running google-authenticator
Create root folder with .google_authenticator

BUILD:
docker build -t ssh-server-otp .

RUN:
docker run -d -P -p 8022:22 -v /docker/ssh-server/root:/root --restart=unless-stopped --name sshd ssh-server-otp
