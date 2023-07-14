FROM jupyter/base-notebook:python-3.8

# install the kernel gateway

RUN pip install --no-cache-dir jupyter_kernel_gateway
ADD requirements.txt /srv/
RUN pip install --no-cache-dir -r /srv/requirements.txt

# run kernel gateway on container start, not notebook server
ADD ./notebooks /srv/notebooks
RUN mkdir -p /tmp/.memory
ENV MEM_DIR /tmp/
WORKDIR /srv/notebooks
EXPOSE 8080

CMD ["jupyter", "kernelgateway", "--KernelGatewayApp.api=notebook-http", "--KernelGatewayApp.ip=0.0.0.0", "--KernelGatewayApp.port=8080", "--KernelGatewayApp.seed_uri=main.ipynb"]
