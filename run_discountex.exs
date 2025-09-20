#!/usr/bin/env elixir

# Simple script to run the discountex CLI without needing to start iex
# Usage: ./run_discountex.exs [keyword] [page]

Mix.install([])

Code.require_file("lib/discountex.ex")
Code.require_file("lib/discountex/cli.ex")

args = System.argv()
Discountex.CLI.main(args)