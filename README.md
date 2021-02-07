## Description

Creating a Docker setup for running Oracle 11c Express Edition in a Docker container for Intershop development.

---
**NOTE**

This build allow you to create a custom Oracle XE database called XE. _This can be used for ICM 7.10 and older._

1.  This docker image does not make use of persistent storage, the database is located in the image and is useful for testing/development.

2.  The password for all database standard users is `intershop`.

3.  The user schema is `intershop` and password is also `intershop`.

---

## Configuration & Startup of a container

Once built, you can run the container example:

```
docker run -p 1521:1521 -p 8080:8080 --name oracle-11g-intershop oracle-11g-intershop
```

Compose File
```
version: "3.4"
services:
  oracle-server:
    image: intershophub/oracle-11g-intershop:latest
    container_name: oracle-intershop
    ports:
    - "1521:1521"
    - "8080:8080"
```

There are no parameters required.

## Connect Local Build Environment (ICM 7.10)

To connect your local ICM development environment with the local docker mssql database your configuration in the `environment.properties` of your development machine should look like this.

```
# Database configuration
databaseType = oracle
jdbcUrl = jdbc:oracle:thin:@host:1521:XE
databaseUser = intershop 
databasePassword = intershop
```

## Build the Container

Build the container image with Ubuntu 18.04 and Oracle 11g XE. Unfortunately it is not allowd to provide 
this binaries for public usage.

The rpm can be downloaded from https://www.oracle.com/database/technologies/xe-prior-releases.html.

The files can be created on Ubuntu with 

```
sudo alien --scripts -d oracle-xe*.rpm
```

Files must be located in the folder "installfiles" of this project.

For internal and automatic usage the files of this project are located in separate project as a submodule.

## License

Copyright 2014-2020 Intershop Communications.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
