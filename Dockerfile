FROM alpine:3.10.1

RUN apk add --no-cache openssh-server-pam openssh-client google-authenticator
RUN mkdir /var/run/sshd

RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
         echo 'ChallengeResponseAuthentication yes' >> /etc/ssh/sshd_config && \
         echo 'UsePAM yes' >> /etc/ssh/sshd_config

RUN echo 'account		include				base-account'  >> /etc/pam.d/sshd && \
         echo 'auth		required			pam_env.so' >> /etc/pam.d/sshd && \
         echo 'auth		required			pam_nologin.so	successok' >> /etc/pam.d/sshd && \
         echo 'auth		include				google-authenticator' >> /etc/pam.d/sshd

RUN ssh-keygen -t rsa -P "" -f /etc/ssh/ssh_host_rsa_key && \
         ssh-keygen -t ecdsa -P "" -f /etc/ssh/ssh_host_ecdsa_key && \
         ssh-keygen -t ed25519 -P "" -f /etc/ssh/ssh_host_ed25519_key

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
VOLUME /root

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

