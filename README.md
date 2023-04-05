# Telegram-In-Range-Message-Scheduler

A simple script to schedule a message randomly in a set range with some conditions.

## Description

The input message is inside a file `message.txt`. The range settings and conditions (including UTC inclusive start and end hours) are set in `settings.json`. This message is scheduled into a specific Telegram chat via tdlib. The telegram-specific date is specified in `.env`.

## Getting Started

### Dependencies

* [npm](https://github.com/npm/cli)
* [purescript](https://www.purescript.org/)
* [spago](https://github.com/purescript/spago)
* [tdlib](https://github.com/tdlib/td)

### Installing

* Run `setup_td.sh` to prepare the tdlib
* Run `npm i` to install the dependencies

### Executing program

* Create or reconfigure `.env` in the format of `.env.example`
* Setup settings in `settings.json`
* Setup the message to be created in `message.txt`
* Run `npm run dev` to run

## License

This project is licensed under the MIT License - see the `LICENSE.md` file for details.

