# Docker, Kubernetes 과제
* Docker
  * Docker Repository
    https://hub.docker.com/repository/docker/jamesby99/nginx-unbuntu
  * Dockerfile
    ```
    FROM ubuntu
    ARG _work_dir="/work"
    WORKDIR ${_work_dir}

    COPY install.sh ${_work_dir}
    RUN chmod 700 ${_work_dir}/install.sh
    RUN ${_work_dir}/install.sh

    ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
    ```
  * install.sh
    ```
    apt update -y
    apt install -y nginx
    ```
  * 실행결과
    ```
    jamesby@ubuntu18:~/docker/build/exercise$ docker run --name nx -d -p 9999:80 jamesby99/nginx-unbuntu
    0332a1b30b977971001f5e447198a83659bbd343406359501aa180f80e441539
    ```
    ```
    jamesby@ubuntu18:~/docker/build/exercise$ docker ps
    CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS               PORTS                  NAMES
    0332a1b30b97        jamesby99/nginx-unbuntu   "nginx -g 'daemon of…"   13 seconds ago      Up 8 seconds        0.0.0. 0:9999->80/tcp   nx
    ```
    ```
    jamesby@ubuntu18:~/docker/build/exercise$ curl localhost:9999
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
    </style>
    </head>
    <body>
    <h1>Welcome to nginx!</h1>
    <p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>

    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>

    <p><em>Thank you for using nginx.</em></p>
    </body>
    </html>
    ```
* Kubernetes
  * YAML : k8s.yaml
    Pod 20개, Service Port 80, AutoScale
  * git