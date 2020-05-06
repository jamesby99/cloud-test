FROM ubuntu

ARG _work_dir="/work"
WORKDIR ${_work_dir}

COPY install.sh ${_work_dir}
RUN chmod 700 ${_work_dir}/install.sh
RUN ${_work_dir}/install.sh

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]