﻿# google-sheets-system-management

 ## Notes

 This project still in progress ...

<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo-small.svg" width="200" alt="Nest Logo" /></a>
</p>

[circleci-image]: https://img.shields.io/circleci/build/github/nestjs/nest/master?token=abc123def456
[circleci-url]: https://circleci.com/gh/nestjs/nest

  <p align="center">A progressive <a href="http://nodejs.org" target="_blank">Node.js</a> framework for building efficient and scalable server-side applications.</p>
    <p align="center">
<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/v/@nestjs/core.svg" alt="NPM Version" /></a>
<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/l/@nestjs/core.svg" alt="Package License" /></a>
<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/dm/@nestjs/common.svg" alt="NPM Downloads" /></a>
<a href="https://circleci.com/gh/nestjs/nest" target="_blank"><img src="https://img.shields.io/circleci/build/github/nestjs/nest/master" alt="CircleCI" /></a>
<a href="https://coveralls.io/github/nestjs/nest?branch=master" target="_blank"><img src="https://coveralls.io/repos/github/nestjs/nest/badge.svg?branch=master#9" alt="Coverage" /></a>
<a href="https://discord.gg/G7Qnnhy" target="_blank"><img src="https://img.shields.io/badge/discord-online-brightgreen.svg" alt="Discord"/></a>
<a href="https://opencollective.com/nest#backer" target="_blank"><img src="https://opencollective.com/nest/backers/badge.svg" alt="Backers on Open Collective" /></a>
<a href="https://opencollective.com/nest#sponsor" target="_blank"><img src="https://opencollective.com/nest/sponsors/badge.svg" alt="Sponsors on Open Collective" /></a>
  <a href="https://paypal.me/kamilmysliwiec" target="_blank"><img src="https://img.shields.io/badge/Donate-PayPal-ff3f59.svg"/></a>
    <a href="https://opencollective.com/nest#sponsor"  target="_blank"><img src="https://img.shields.io/badge/Support%20us-Open%20Collective-41B883.svg" alt="Support us"></a>
  <a href="https://twitter.com/nestframework" target="_blank"><img src="https://img.shields.io/twitter/follow/nestframework.svg?style=social&label=Follow"></a>
</p>

<a href="https://flutter.dev/">
  <h1 align="center">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://storage.googleapis.com/cms-storage-bucket/6e19fee6b47b36ca613f.png">
      <img alt="Flutter" src="https://storage.googleapis.com/cms-storage-bucket/c823e53b3a1a7b0d36a9.png">
    </picture>
  </h1>
</a>

[![Flutter CI Status](https://flutter-dashboard.appspot.com/api/public/build-status-badge?repo=flutter)](https://flutter-dashboard.appspot.com/#/build?repo=flutter)
[![Discord badge][]][Discord instructions]
[![Twitter handle][]][Twitter badge]
[![codecov](https://codecov.io/gh/flutter/flutter/branch/master/graph/badge.svg?token=11yDrJU2M2)](https://codecov.io/gh/flutter/flutter)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/5631/badge)](https://bestpractices.coreinfrastructure.org/projects/5631)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/flutter/flutter/badge)](https://deps.dev/project/github/flutter%2Fflutter)
[![SLSA 1](https://slsa.dev/images/gh-badge-level1.svg)](https://slsa.dev)

Flutter is Google's SDK for crafting beautiful, fast user experiences for
mobile, web, and desktop from a single codebase. Flutter works with existing
code, is used by developers and organizations around the world, and is free and
open source.

## Contents

- [Description](#description)
- [API Documentation](#api-documentation)
- [Setup](#setup)
- [Running the app](#running-the-app)
- [Test](#test)
- [Support](#support)
- [Licence](#licence)


## Description

This is a google drive and google sheets managment system that allows you to make a crud operations: append ,updatE and manage google sheets (as pagenated data table).

Built with NestJS using googleapis, and flutter as frontend to support multi platforms at one code.

<a href="https://flutter.dev/">Flutter</a> is Google’s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.

## API Documentation

This project uses Swagger UI as an interactive documentation for the API. After running the application, you can access the Swagger UI at `http://localhost:8000/api`.

The Swagger UI setup can be found in the [main.ts](./backend/src/main.ts) file.

## Setup

Clone the project

```bash
$ git clone https://github.com/olaib/Fullstack-Google-Drive-and-Google-Sheets-Management-System-.git
```

Go to the project directory

```bash
$ cd Fullstack-Google-Drive-and-Google-Sheets-Management-System
```

Install depencies for backend

```bash
$ cd backend
```

```bash
$ npm install
```

Navigate to the frontend folder then install the depencies

```bash
$ flutter pub get
```

IMPORTANT: you have to make sure that the enviroment variables in backend/.env are replaced with yours.

## Running the app

### Backend

```bash
# development watch mode
$ npm run start:dev

# production mode
% npm run start:prod
```

### Frontend

for web:

```bash
$ flutter run -d chrome
```

for android []

```bash
# get the id of your IOS/Android device 
$ flutter devices
# then you can run the application
$ flutter run -d <your_device_id>
```


## Test

```bash
# unit tests
$ npm run test

# test coverage
$ npm run test:cov
```

## Support

For additional help or questions about using NestJS, please visit the [NestJS Support Page](https://docs.nestjs.com/support).

## Licence

Nest is [MIT licened](LICENSE)
