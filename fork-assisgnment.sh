#!/bin/bash

# Load environment variables from the .env file
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

echo "=========================="
echo "Forking Assignment Started"
echo "=========================="

TEMPLATE="$ORGANIZATION/$REPO"

for STUDENT in $(cat students.txt); do
  echo "Processing $STUDENT..."

  gh repo fork "$TEMPLATE" --clone=false --remote=false --org="$ORGANIZATION" --fork-name="$REPO-$STUDENT"

  STUDENT_REPO="$ORGANIZATION/$REPO-$STUDENT"

  gh repo edit "$STUDENT_REPO" --visibility private

  gh api \
        --method PUT \
        -H "Accept: application/vnd.github+json" \
        "/repos/$STUDENT_REPO/collaborators/$STUDENT" \
        -f permission=push > /dev/null 2>&1

  echo "Completed setup for $STUDENT."
done

echo "=========================="
echo "Forking Assignment Completed"
echo "=========================="
