#!/bin/bash
# create the main directory
mkdir -p submission_reminder_app/{app,config,modules,assets}

touch submission_reminder_app/config/config.env
touch submission_reminder_app/app/reminder.sh && chmod u+x submission_reminder_app/app/reminder.sh
touch submission_reminder_app/modules/functions.sh && chmod u+x submission_reminder_app/modules/functions.sh
touch submission_reminder_app/startup.sh && chmod u+x submission_reminder_app/startup.sh
touch submission_reminder_app/assets/submissions.txt

echo 'student, assignment, submission status
here, Shell Navigation, submitted
Noel, Shell Navigation, not submitted
chris, Shell Navigation, not submitted
anaiza, Shell Navigation, not submitted
roy, Shell Navigation, submitted
susu, Shell Navigation, not submitted
greta, Shell Navigation, submitted' > submission_reminder_app/assets/submissions.txt

echo '# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2' > submission_reminder_app/config/config.env

echo '#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}' > submission_reminder_app/modules/functions.sh

echo '#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file' > submission_reminder_app/app/reminder.sh

echo '#!/bin/bash
./submission_reminder_app/app/reminder.sh' > submission_reminder_app/startup.sh

./submission_reminder_app/startup.sh
