
import os
import streamlit as st
st.set_page_config(layout='wide', page_title='Coop')


st.title('Hello World')
env_type = os.environ.get('ENV_TYPE', 'dev')
if env_type == 'dev':
    st.markdown(f'#### :blue[Development]')
    st.write(f'Port No : {os.environ.get("PORT")}')
elif env_type == 'stage':
    st.markdown(f'#### :blue[Staging/Testing]')
elif env_type == 'prod':
    st.markdown(f'#### :blue[Production]')