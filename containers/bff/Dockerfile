FROM mambaorg/micromamba:1.5.6
COPY --chown=$MAMBA_USER:$MAMBA_USER env.yaml /tmp/env.yaml
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes
ENV PATH "$MAMBA_ROOT_PREFIX/bin:$PATH"
RUN R -e "remotes::install_github('bimberlab/cellhashR@1.04')"
