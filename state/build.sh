#!/bin/bash -xe

TARGET=${1:-'*'}

sudo salt "$TARGET" state.apply
