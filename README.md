# rsyslog-distroless
rsyslog 8.24.0 base distroless

```
docker run -d --name rsyslog \
  -p 514:514 \
  -p 514:514/udp \
  kyos0109/rsyslog-distroless
```
