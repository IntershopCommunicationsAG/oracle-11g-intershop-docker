#
# Copyright 2021 Intershop Communications AG.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
FROM alpine AS PREPBIN

ARG AUTH_TOKEN

RUN apk --update add curl
RUN curl -H "Authorization: token $AUTH_TOKEN" -L https://api.github.com/repos/IntershopCommunicationsAG/oracle-11g-intershop/tarball > pkg.tar.gz
RUN mkdir oraclepkgs && tar -zxvf pkg.tar.gz && mv IntershopCommunicationsAG-oracle-11g*/* oraclepkgs

FROM ubuntu:18.04

LABEL maintainer="a-team@intershop.de"

COPY assets /assets
COPY --from=PREPBIN oraclepkgs /assets

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y libaio1 net-tools bc && \
    ln -s /usr/bin/awk /bin/awk && \
    mkdir /var/lock/subsys && \
    mv /assets/chkconfig /sbin/chkconfig && \
    chmod 755 /sbin/chkconfig && \
    cat /assets/oracle-xe_11.2.0-1.0_amd64.deba* > /assets/oracle-xe_11.2.0-1.0_amd64.deb && \
    dpkg --install /assets/oracle-xe_11.2.0-1.0_amd64.deb && \
    mv /assets/init.ora /u01/app/oracle/product/11.2.0/xe/config/scripts && \
    mv /assets/initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts && \
    cp /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora.tmpl && \
    cp /u01/app/oracle/product/11.2.0/xe/network/admin/tnsnames.ora /u01/app/oracle/product/11.2.0/xe/network/admin/tnsnames.ora.tmpl && \
    mv /assets/startup.sh /usr/sbin/startup.sh && chmod +x /usr/sbin/startup.sh

RUN /assets/setup.sh

RUN rm -r /assets/

EXPOSE 1521
EXPOSE 8080

ENTRYPOINT [ "/usr/sbin/startup.sh" ]