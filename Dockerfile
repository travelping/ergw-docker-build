FROM ubuntu:xenial

ARG ERLANG_VERSION=1:21.1.1+dfsg-2+ubuntu16.04~ppa0
ARG REBAR_VERSION=3.7.5

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 58A14C3D
RUN echo "deb http://ppa.launchpad.net/ergw/xenial/ubuntu xenial main" > /etc/apt/sources.list.d/ergw-xenial-ppa.list

RUN apt-get update && apt-get install -y \
    curl apt-transport-https \
    build-essential debhelper devscripts equivs gettext \
    git erlang-base-hipe=$ERLANG_VERSION erlang-dev=$ERLANG_VERSION erlang-tools=$ERLANG_VERSION \
    erlang-syntax-tools=$ERLANG_VERSION erlang-eunit=$ERLANG_VERSION erlang-common-test=$ERLANG_VERSION \
    erlang-inets=$ERLANG_VERSION erlang-snmp=$ERLANG_VERSION erlang-diameter=$ERLANG_VERSION \
    erlang-dialyzer=$ERLANG_VERSION erlang-ssl=$ERLANG_VERSION erlang-os-mon=$ERLANG_VERSION

COPY rebar3-dummy.tpl .
RUN ( \
        cd /usr/bin && \
        curl -L -O https://github.com/erlang/rebar3/releases/download/$REBAR_VERSION/rebar3 && \
        chmod a+x rebar3 ) && \
    envsubst < rebar3-dummy.tpl > rebar3-dummy && \
    equivs-build rebar3-dummy && \
    dpkg -i rebar3-dummy_${REBAR_VERSION}_all.deb && \
    rm -f rebar3*

WORKDIR /build

CMD ["bash"]
