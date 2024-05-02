#!/bin/bash
clear

intro_message=$(cat <<EOF
Cron scheduling for "nth day" of the month.

When scheduling tasks for specific dates like the 3rd Tuesday or 2nd Friday of the month, there's no direct built-in method available in cron.
Instead, you'll have to employ shell scripting to accomplish this.

This script will automatically output the line that can be used for the crontab entry.
 
EOF
)
echo "$intro_message"


# Function to validate minute input
validate_minute_input() {
    read -p "Enter the minute (0-59 or *): " minute
    if ! [[ "$minute" =~ ^[0-9*]+$ && ( "$minute" == "*" || ( "$minute" -ge 0 && "$minute" -le 59 ) ) ]]; then
        echo "Invalid input. Minute must be a number between 0 and 59 or *."
        validate_minute_input
    fi
}

# Function to validate hour input
validate_hour_input() {
    read -p "Enter the hour (0-23 or *): " hour
    if ! [[ "$hour" =~ ^[0-9*]+$ && ( "$hour" == "*" || ( "$hour" -ge 0 && "$hour" -le 23 ) ) ]]; then
        echo "Invalid input. Hour must be a number between 0 and 23 or *."
        validate_hour_input
    fi
}

# Function to validate day of week input
validate_day_of_week_input() {
    read -p "Enter the day of week (0-6, Sunday=0, Saturday=6): " day_of_week
    if ! [[ "$day_of_week" =~ ^[0-6]$ ]]; then
        echo "Invalid input. Day of week must be a number between 0 and 6."
        validate_day_of_week_input
    fi
}

# Function to validate choice for day occurrence
validate_day_occurrence_choice() {
    read -p "Enter your choice (1-4): " choice
    case $choice in
        1|2|3|4) return;;
        *) echo "Invalid choice"; validate_day_occurrence_choice;;
    esac
}

# Function to prompt user for the command
prompt_command() {
    read -p "Enter the command or script with full path to be executed: " command
}

# Validate user input for each parameter
validate_minute_input
validate_hour_input
validate_day_of_week_input

# Present menu for choosing the occurrence of the day
echo "Choose the occurrence of the day:"
echo "1. 1st 'X' of the month."
echo "2. 2nd 'X' of the month."
echo "3. 3rd 'X' of the month."
echo "4. 4th 'X' of the month."

# Validate choice for day occurrence
validate_day_occurrence_choice

# Prompt user for the command
prompt_command

# Convert user choice to corresponding day occurrence
case $choice in
    1) day_occurrence="1-7";;
    2) day_occurrence="8-14";;
    3) day_occurrence="15-21";;
    4) day_occurrence="22-28";;
esac

# Create the cron job entry
cron_job="$minute $hour $day_occurrence * * test \$(date +\\%u) -eq $day_of_week && $command"
# Display the generated cron job entry
echo
echo "Generated cron job entry:"
echo
echo "$cron_job"
echo
