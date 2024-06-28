#!/bin/bash

dart pub global activate dcdg
dart pub global run dcdg
sed -i "1s/.*/@startuml class-diagram/" ./docs/class-diagram.puml