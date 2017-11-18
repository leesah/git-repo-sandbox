FROM ubuntu:latest

ENV USERNAME "developer"
ENV REMOTES "/remotes"
ENV MANIFEST_REPO "${REMOTES}/remote-00/manifest.git"
ENV DEFAULT_XML "${MANIFEST_REPO}/default.xml"

RUN apt-get update \
 && apt-get install --yes \
        git repo \
        bash-completion man-db vim \
 && apt-get autoclean \
 && mkdir -m 777 "${REMOTES}" \
 && adduser --disabled-password --gecos "" "${USERNAME}"

USER "${USERNAME}"

RUN git config --global user.name "Developer" \
 && git config --global user.email "developer@example.com" \
 && git init -q "${MANIFEST_REPO}" \
 && echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?><manifest>" >> "${DEFAULT_XML}" \
 && for r in $(seq -f "remote-%02g" 1 2); do \
      echo "  <remote  name=\"${r}\" fetch=\"${REMOTES}/${r}\" />" >> "${DEFAULT_XML}"; \
      for n in $(seq -f "project-%02g" 1 8); do \
        p="${REMOTES}/${r}/${n}.git"; \
        git init -q "${p}"; \
        touch "${p}/README.md"; \
        git -C "${p}" add README.md; \
        git -C "${p}" commit -q -m "Adding README.md"; \
        echo "  <project remote=\"${r}\" name=\"${n}\" path=\"${r}.${n}\" revision=\"refs/heads/master\" />" >> "${DEFAULT_XML}"; \
      done \
    done \
 && echo "</manifest>" >> "${DEFAULT_XML}" \
 && git -C "${MANIFEST_REPO}" add "${DEFAULT_XML}" \
 && git -C "${MANIFEST_REPO}" commit -q -m "Adding manifest"

WORKDIR "/home/${USERNAME}"
