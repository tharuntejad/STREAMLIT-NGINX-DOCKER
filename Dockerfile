FROM python:3.8-slim-buster


WORKDIR /usr/src/app
COPY . .
RUN chmod -R 777 /usr/src/app
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Set default environment to 'dev' and default port on which each container runs to 8501
ENV ENV_TYPE='dev'
ENV PORT=8501
ENV ROOT_PATH='/usr/src/app'
RUN echo "env: $ENV_TYPE , rootpath: $ROOT_PATH ,port: $PORT"


ENTRYPOINT ["./launch_app.sh"]
# EXPOSE 8501
# ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]

# sudo docker build --tag coops:v1 ./
# sudo docker container run -e ENV_TYPE='stage'  -p 80:8501  -d --name copcon_stage_1 coops:v1