#!/bin/bash

echo "Running launch_app.sh"
echo "Environment : $ENV_TYPE"
echo "Port        : $PORT"

# Launch the Streamlit app
streamlit run app.py --server.port "$PORT"

# commands to start app in linux, mac
# bash launch_app.sh dev 8501
# bash launch_app.sh stage 8501
# bash launch_app.sh prod 8501