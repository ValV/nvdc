FROM nvcr.io/nvidia/tensorflow:20.03-tf2-py3

ENV TINI_VERSION v0.19.0

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini

RUN chmod +x /usr/bin/tini && jupyter notebook --generate-config && export PASSWD=$(python -c 'from notebook.auth import passwd; print(passwd("nevermore"))') && sed -i -e "s/#\(c.NotebookApp.password = '\)/\1$PASSWD/" ~/.jupyter/jupyter_notebook_config.py && ln -s /usr/local/cuda/compat/lib{.real,}

ENTRYPOINT ["/usr/bin/tini", "--"]
EXPOSE 80
CMD ["jupyter", "notebook", "--port=80", "--no-browser", "--ip=0.0.0.0"]
