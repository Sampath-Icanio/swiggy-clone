#!/bin/bash
# ============================================================
# MANUAL DEPLOYMENT SCRIPT — "The Old Way"
# ============================================================
# TEACHING POINT: Show this script FIRST.
# This is what a DevOps engineer used to do manually
# every single time a change needed to go live.
#
# Ask the interns: "What if you had to do this 10 times a day?
# What if you made a typo at step 6? What if you forgot step 4?
# What if it was 2 AM during Diwali and production was down?"
#
# Then show them GitHub Actions doing all of this automatically.
# ============================================================

set -e   # Stop script if any command fails

echo ""
echo "=============================================="
echo "  MANUAL DEPLOYMENT — Swiggy Clone"
echo "=============================================="
echo ""

# ── STEP 1: SSH into the server
echo "[Step 1/9] SSH into AWS EC2 server..."
echo "  Running: ssh -i ~/.ssh/swiggy-key.pem ec2-user@<EC2_IP>"
echo "  ⏳ Waiting for connection..."
sleep 1
echo "  ✅ Connected to EC2"
echo ""

# ── STEP 2: Pull latest code
echo "[Step 2/9] Pull latest code from GitHub..."
echo "  Running: git pull origin main"
sleep 1
echo "  ✅ Code updated (3 files changed)"
echo ""

# ── STEP 3: Build Docker image with theme
echo "[Step 3/9] Build Docker image..."
echo "  Running: docker build --build-arg ACTIVE_THEME=diwali -t swiggy-clone:latest ."
echo "  ⏳ Building... (this takes 2-3 minutes)"
sleep 2
echo "  ✅ Image built: swiggy-clone:latest"
echo ""

# ── STEP 4: Stop old container
echo "[Step 4/9] Stop old container..."
echo "  Running: docker stop swiggy-clone"
sleep 1
echo "  ✅ Old container stopped"
echo "  ⚠️  SITE IS DOWN RIGHT NOW — users cannot order food"
echo ""

# ── STEP 5: Remove old container
echo "[Step 5/9] Remove old container..."
echo "  Running: docker rm swiggy-clone"
sleep 1
echo "  ✅ Old container removed"
echo ""

# ── STEP 6: Start new container
echo "[Step 6/9] Start new container..."
echo "  Running: docker run -d --name swiggy-clone -p 80:80 swiggy-clone:latest"
sleep 1
echo "  ✅ New container started"
echo ""

# ── STEP 7: Verify it's running
echo "[Step 7/9] Verify container is running..."
echo "  Running: docker ps | grep swiggy-clone"
sleep 1
echo "  ✅ Container running — port 80 active"
echo ""

# ── STEP 8: Health check
echo "[Step 8/9] Run health check..."
echo "  Running: curl http://localhost/health"
sleep 1
echo "  ✅ Response: {\"status\":\"ok\",\"app\":\"swiggy-clone\"}"
echo ""

# ── STEP 9: Push image to Docker Hub (for backup)
echo "[Step 9/9] Push image to Docker Hub..."
echo "  Running: docker tag swiggy-clone:latest username/swiggy-clone:latest"
echo "  Running: docker push username/swiggy-clone:latest"
sleep 1
echo "  ✅ Image pushed to registry"
echo ""

echo "=============================================="
echo "  ✅ DEPLOYMENT COMPLETE"
echo "  Time taken: ~8 minutes"
echo "  Steps done manually: 9"
echo "  Chances for human error: 9"
echo "  Site downtime: ~15 seconds"
echo "=============================================="
echo ""
echo "  ❓ QUESTION FOR INTERNS:"
echo "  What if you had to do this every day?"
echo "  What if the festival started at midnight?"
echo "  What if you mistyped the theme name?"
echo "  What if 3 people deployed at the same time?"
echo ""
echo "  👉 There is a better way. Let's build it."
echo ""
