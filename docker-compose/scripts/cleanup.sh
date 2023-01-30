#!/bin/bash

DIR="$( cd .. && pwd )"

rm -f *.json
cd ../ && docker-compose down --remove-orphans