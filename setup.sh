#!/bin/bash

get_data() {
  local endpoint=$1
  curl -s "http://localhost:3033$endpoint" | jq -r .
}

get_latest_chain_height() {
  curl -s "https://f5nodes.com/api/aleo/blocks" | jq -r .maxHeight
}

display_table() {
  echo "----------------------------------------------"
  echo "| Endpoint                        | Data     |"
  echo "----------------------------------------------"
  echo "| Latest Chain Height             | $(get_latest_chain_height) |"
  echo "| Latest Node Height              | $(get_data /testnet3/latest/height) |"
  echo "| Latest Hash                     | $(get_data /testnet3/latest/hash) |"
  echo "| Latest State Root               | $(get_data /testnet3/latest/stateRoot) |"
  echo "| Peers Count                     | $(get_data /testnet3/peers/count) |"
  echo "----------------------------------------------"
  echo "| Validators IP and Ports         |"
  echo "----------------------------------------------"

  # Fetch validator data
  validator_data=$(get_data /testnet3/peers/all/metrics | jq -r '.[] | select(.[1] == "Validator") | "\(.[0])"')

  # Display indexed validator data
  index=1
  while read -r validator; do
    echo "| Validator $index                  | $validator |"
    ((index++))
  done <<< "$validator_data"

  echo "----------------------------------------------"
}

display_table
