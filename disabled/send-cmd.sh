#!/bin/bash

run_in_session() {
   screen -S $MC_SESSION_NAME -X stuff "$1^M"
}