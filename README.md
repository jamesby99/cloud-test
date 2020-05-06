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
* Kubernetes : YAML파일 사용했습니다.
  * YAML : k8s.yaml
    Pod 20개, Service Port 80, AutoScale, NFS
  * 실행방법
    ```
    kubectl apply -f k8s.yaml
    ```
  * k8s.yaml
    ```
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: nginx-demo
    spec:
      replicas: 20

      selector:
        matchLabels:
          type: app
          service: nginx-demo
      template:
        metadata:
          labels:
            type: app
            service: nginx-demo
        spec:
          containers:
          - name: nginx-demo
            image: jamesby99/nginx-unbuntu
            livenessProbe:
              httpGet:
                path: /
                port: 80
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: nginx-demo
    spec:
      type: NodePort
      type: LoadBalancer
      ports:
      - port: 80
        targetPort: 80
        protocol: TCP
      selector:
        type: app
        service: nginx-demo
    ---
    apiVersion: autoscaling/v1
    kind: HorizontalPodAutoscaler
    metadata:
      name: hpa-execise
    spec:
      maxReplicas: 30
      minReplicas: 10
      scaleTargetRef:
        apiVersion: extensions/v1
        kind: Deployment
        name: nginx-demo
      targetCPUUtilizationPercentage: 80
    ```
  * 실행결과
    * kubectl get all

      ```
      NAME                              READY   STATUS    RESTARTS   AGE
      pod/nginx-demo-69b488c5f6-4qm8f   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-56h4c   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-88lf2   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-bg9dn   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-bh7js   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-c6rwl   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-h6c8s   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-hff9s   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-hnllp   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-hvrdx   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-jj6dz   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-llmh6   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-m64mr   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-nrjcb   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-qxtjn   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-sss7t   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-v9rxz   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-wbwhk   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-zht9j   1/1     Running   0          4m36s
      pod/nginx-demo-69b488c5f6-zww97   1/1     Running   0          4m36s


      NAME                 TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
      service/kubernetes   ClusterIP      10.254.0.1      <none>        443/TCP        5d16h
      service/nginx-demo   LoadBalancer   10.254.115.52   <pending>     80:30574/TCP   4m36s


      NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
      deployment.apps/nginx-demo   20/20   20           20          4m36s

      NAME                                    DESIRED   CURRENT   READY   AGE
      replicaset.apps/nginx-demo-69b488c5f6   20        20        20      4m36s


      NAME                                              REFERENCE               TARGETS         MINPODS   MAXPODS   REPLICAS        AGE
      horizontalpodautoscaler.autoscaling/hpa-execise   Deployment/nginx-demo   <unknown>/80%   10        30        20              4m35s
      ```
    * HTTP Request
      ```
      [root@node1 execise]# curl 10.254.115.52:80
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
      <p>If you see this page, the nginx web server is successfully       installed and
      working. Further configuration is required.</p>

      <p>For online documentation and support please refer to
      <a href="http://nginx.org/">nginx.org</a>.<br/>
      Commercial support is available at
      <a href="http://nginx.com/">nginx.com</a>.</p>

      <p><em>Thank you for using nginx.</em></p>
      </body>
      </html>
      ```