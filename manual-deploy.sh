#!/bin/bash
# ============================================================
# MANUAL DEPLOYMENT SCRIPT — "The Old Way"
# ============================================================
# TEACHING POINT: Show this script FIRST.
# Run it and use the wait time between steps to talk to interns.
# Each step pauses so you can explain what is happening and why.
# ============================================================

set -e

# ── COLOURS for readability in terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ── WAIT function — prints a countdown so interns can see time passing
wait_with_countdown() {
  local seconds=$1
  local message=$2
  echo -e "  ${CYAN}${message}${RESET}"
  for ((i=seconds; i>0; i--)); do
    printf "\r  ${YELLOW}  continuing in %2d seconds...${RESET}" $i
    sleep 1
  done
  printf "\r%-50s\r" " "
}

clear
echo ""
echo -e "${BOLD}=============================================="
echo "   MANUAL DEPLOYMENT — Swiggy Clone"
echo -e "==============================================${RESET}"
echo -e "  ${CYAN}Festival theme: Diwali${RESET}"
echo -e "  ${CYAN}Server: AWS EC2 — 13.232.254.219${RESET}"
echo ""
echo -e "  ${YELLOW}This is how deployments were done manually."
echo -e "  Watch every step — and think about how many"
echo -e "  things could go wrong at 2 AM during Diwali.${RESET}"
echo ""

wait_with_countdown 5 "Starting deployment in 5 seconds..."

echo ""
echo -e "${BOLD}----------------------------------------------${RESET}"

# ── STEP 1
echo ""
echo -e "${BOLD}[Step 1/9] SSH into AWS EC2 server${RESET}"
echo "  Command: ssh -i ~/.ssh/swiggy-key.pem ec2-user@13.232.254.219"
echo ""
echo -e "  ${YELLOW}TALK TO INTERNS:${RESET}"
echo "  Every deployment starts here — manually SSHing into the server."
echo "  You need the .pem key file on your laptop."
echo "  If you are working from a different machine, you need to copy the key first."
echo ""
wait_with_countdown 8 "Simulating SSH connection..."
echo -e "  ${GREEN}Connected to EC2 successfully${RESET}"
echo ""

# ── STEP 2
echo -e "${BOLD}[Step 2/9] Navigate to project directory${RESET}"
echo "  Command: cd /home/ec2-user/swiggy-clone"
echo ""
echo -e "  ${YELLOW}TALK TO INTERNS:${RESET}"
echo "  Now we are inside the server. The code lives in this folder."
echo "  If someone else deployed last and left the folder messy, you clean it up first."
echo ""
wait_with_countdown 5 "Navigating to project directory..."
echo -e "  ${GREEN}Now inside: /home/ec2-user/swiggy-clone${RESET}"
echo ""

# ── STEP 3
echo -e "${BOLD}[Step 3/9] Pull latest code from GitHub${RESET}"
echo "  Command: git pull origin main"
echo ""
echo -e "  ${YELLOW}TALK TO INTERNS:${RESET}"
echo "  We pull the latest code from GitHub onto the server."
echo "  If someone pushed a bad commit, we are about to pull that too."
echo "  There is no automatic check here — we just trust it."
echo ""
wait_with_countdown 7 "Pulling latest code from GitHub..."
echo -e "  ${GREEN}Code updated — 3 files changed${RESET}"
echo ""

# ── STEP 4
echo -e "${BOLD}[Step 4/9] Build Docker image with festival theme${RESET}"
echo "  Command: docker build --build-arg ACTIVE_THEME=diwali -t swiggy-clone:latest ."
echo ""
echo -e "  ${YELLOW}TALK TO INTERNS:${RESET}"
echo "  Now we build the Docker image — this bakes the theme into the app."
echo "  If you mistype 'diwali' here — say you write 'Diwali' with a capital D —"
echo "  the wrong theme goes live and you do not know until a user reports it."
echo "  Docker build usually takes 2 to 4 minutes on a fresh server."
echo ""
wait_with_countdown 10 "Building Docker image (theme: diwali)..."
echo -e "  ${GREEN}Image built successfully: swiggy-clone:latest${RESET}"
echo ""

# ── STEP 5
echo -e "${BOLD}[Step 5/9] Stop the running container${RESET}"
echo "  Command: docker stop swiggy-clone"
echo ""
echo -e "  ${YELLOW}TALK TO INTERNS:${RESET}"
echo "  We have to stop the old container before starting the new one."
echo "  Right now — at this exact moment — the site is going down."
echo "  Every user trying to order food is getting an error."
echo ""
wait_with_countdown 6 "Stopping old container..."
echo -e "  ${GREEN}Container stopped${RESET}"
echo -e "  ${RED}SITE IS DOWN — users cannot access the app right now${RESET}"
echo ""

# ── STEP 6
echo -e "${BOLD}[Step 6/9] Remove the old container${RESET}"
echo "  Command: docker rm swiggy-clone"
echo ""
echo -e "  ${YELLOW}TALK TO INTERNS:${RESET}"
echo "  We remove the old container completely before creating a new one."
echo "  If you forget this step and try to run the new container,"
echo "  Docker throws an error because the name is already taken."
echo "  The site is still down during this step."
echo ""
wait_with_countdown 5 "Removing old container..."
echo -e "  ${GREEN}Old container removed${RESET}"
echo ""

# ── STEP 7
echo -e "${BOLD}[Step 7/9] Start the new container${RESET}"
echo "  Command: docker run -d --name swiggy-clone -p 80:80 swiggy-clone:latest"
echo ""
echo -e "  ${YELLOW}TALK TO INTERNS:${RESET}"
echo "  Now we start the new container with the updated image."
echo "  The -p 80:80 maps port 80 on the server to port 80 in the container."
echo "  If you forget that flag, the site is unreachable from the browser."
echo "  The site should be back up in a few seconds."
echo ""
wait_with_countdown 7 "Starting new container..."
echo -e "  ${GREEN}New container started — swiggy-clone is running${RESET}"
echo ""

# ── STEP 8
echo -e "${BOLD}[Step 8/9] Run health check${RESET}"
echo "  Command: curl http://localhost/health"
echo ""
echo -e "  ${YELLOW}TALK TO INTERNS:${RESET}"
echo "  We manually curl the health endpoint to verify the app responded."
echo "  This is a manual check — if you forget this step and the app is broken,"
echo "  you find out when a user calls to complain, not before."
echo ""
wait_with_countdown 6 "Running health check..."
echo -e "  ${GREEN}Response: {\"status\":\"ok\",\"app\":\"swiggy-clone\"}${RESET}"
echo -e "  ${GREEN}Site is back up${RESET}"
echo ""

# ── STEP 9
echo -e "${BOLD}[Step 9/9] Push image to Docker Hub${RESET}"
echo "  Command: docker tag swiggy-clone:latest sampathkumar998/swiggy-clone:latest"
echo "  Command: docker push sampathkumar998/swiggy-clone:latest"
echo ""
echo -e "  ${YELLOW}TALK TO INTERNS:${RESET}"
echo "  Finally we push the image to Docker Hub as a backup."
echo "  If the server crashes, we can pull this image and redeploy."
echo "  This step is easy to forget when you are tired at 2 AM."
echo ""
wait_with_countdown 8 "Pushing image to Docker Hub..."
echo -e "  ${GREEN}Image pushed: sampathkumar998/swiggy-clone:latest${RESET}"
echo ""

# ── SUMMARY
echo -e "${BOLD}=============================================="
echo "   DEPLOYMENT COMPLETE"
echo -e "==============================================${RESET}"
echo ""
echo -e "  ${GREEN}Status:      Live${RESET}"
echo    "  Time taken:  ~9 minutes"
echo    "  Manual steps: 9"
echo    "  Human error opportunities: 9"
echo    "  Site downtime: ~25 seconds"
echo    "  Steps that could silently fail: 4"
echo ""
echo -e "${BOLD}----------------------------------------------${RESET}"
echo ""
echo -e "  ${YELLOW}NOW ASK THE INTERNS:${RESET}"
echo ""
echo    "  1. What if you had to do this 10 times a day?"
echo    "  2. What if the festival started at midnight?"
echo    "  3. What if you mistyped 'diwali' at step 4?"
echo    "  4. What if two engineers deployed at the same time?"
echo    "  5. What if you forgot step 6 and the port flag?"
echo    "  6. What if no one ran the health check?"
echo ""
echo -e "  ${CYAN}There is a better way. Let us build it.${RESET}"
echo ""
