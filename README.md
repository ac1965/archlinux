Arch Linux Dockerfile for my testing / packaging environment

- base-devel
- multilib
- sudo (user: `pwner`)
- yay


```
make
make dockerhub_push
docker pull ac196/archlinux
```

```
kubectl run archlinux --image=ac1965/archlinux
kubectl get pod -o wide
kubectl delete pod archlinux
```
