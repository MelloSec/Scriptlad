# Print the help menu
function print_help {
  echo "Usage: bash script.sh [-s script] [-a args] [-i input] output_file"
  echo ""
  echo "Options:"
  echo "  -s, --script      The script to run. If not specified, the user will be prompted for it."
  echo "  -a, --args        The arguments to pass to the script. If not specified, no arguments will be passed."
  echo "  -i, --input       The input file or '-n' for no input. If not specified, the user will be prompted for it."
  echo "  -h, --help        Show this help menu."
  echo "  output_file       The output file. If not specified, the user will be prompted for it."
}

# Initialize variables
script=""
args=""
input=""
input_file="/dev/null"

# Parse the command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--script)
      script=$2
      shift 2
      ;;
    -a|--args)
      args=$2
      shift 2
      ;;
    -i|--input)
      if [[ $2 == "-n" ]]; then
        input=$3
        shift 3
      else
        input_file=$2
        shift 2
      fi
      ;;
    -h|--help)
      print_help
      exit
      ;;
    *)
      output_file=$1
      shift
      ;;
  esac
done

# Prompt the user for the script if it's not set
if [[ -z "$script" ]]; then
  read -e -p "Enter the script: " script
fi

# Prompt the user for the input file if it's not set
if [[ "$input_file" == "/dev/null" ]]; then
  read -e -p "Enter the input file or '-n' for no input: " input_file
fi

# Prompt the user for the output file if it's not set
if [[ -z "$output_file" ]]; then
  read -e -p "Enter the output file: " output_file
fi

# Clear the output file
echo "" > "$output_file"

# Read the input file line by line
while read -r line || [[ -n "$input" ]]; do
  # Set the line to the input if it's not empty
  if [[ -n "$input" ]]; then
    line=$input
    # Set the input to an empty string to exit the loop
    input=""
  fi

  # Check if the script ends in ".py"
  if [[ "$script" == *.py ]]; then
    # Run the script with python3 and append the output to the output file
    python3 "$script" "$args" "$line" >> "$output_file"
  # Check if the script ends in ".sh"
  elif [[ "$script" == *.sh ]]; then
    # Run the script with bash and append the output to the output file
    bash "$script" "$args" "$line" >> "$output_file"
  else
    # Run the script and append the output to the output file
    "$script" "$args" "$line" >> "$output_file"
  fi
done < "$input_file"
