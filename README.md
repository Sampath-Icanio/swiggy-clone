# Swiggy Clone — DevOps Training Demo
### Day 4, Session 2 | Presenter: Sampath Kumar

---

## Your Teaching Flow (90 minutes)

### Phase 1 — Manual deploy (show the pain) [10 min]
Run the manual deploy script to show interns what deployment looked like before CI/CD:
```bash
bash manual-deploy.sh
```
Ask them: *"What if you had to do this 10 times a day? What if it's 2 AM?"*

---

### Phase 2 — Show the app running (default theme) [5 min]
```bash
# Build with default theme
docker build --build-arg ACTIVE_THEME=default -t swiggy-clone:latest .
docker run -d --name swiggy-clone -p 8080:80 swiggy-clone:latest

# Open in browser
open http://localhost:8080
```

---

### Phase 3 — Build the pipeline live [35 min]
Build `.github/workflows/deploy.yml` incrementally — one job at a time.
Each job maps to a real pain point from the manual script:

| Manual step | Pipeline equivalent |
|---|---|
| SSH into server | `appleboy/ssh-action` |
| `docker build` | `docker build` step with `--build-arg` |
| `docker stop` + `docker run` | SSH script block |
| Health check | `curl /health` in deploy script |
| Credentials in terminal | `secrets.DOCKER_PASSWORD` |

---

### Phase 4 — The live theme change (the wow moment) [15 min]
This is the highlight of your session.

**Step 1:** Show the site with default theme on screen

**Step 2:** Go to GitHub → Settings → Secrets → Update `ACTIVE_THEME`:
```
default   →  diwali
```

**Step 3:** Make a tiny change to trigger the pipeline (e.g. update a headline in index.html):
```html
<!-- Change this -->
<h1 id="hero-headline">Order food &amp; groceries online</h1>

<!-- To this -->
<h1 id="hero-headline">Order food &amp; groceries online 🎉</h1>
```

**Step 4:** Commit and push:
```bash
git add .
git commit -m "feat: trigger diwali theme deployment"
git push origin main
```

**Step 5:** Go to GitHub Actions tab — watch the pipeline run live.

**Step 6:** When it goes green, open the EC2 IP in browser.
- Banner appears: *"Happy Diwali! Flat 60% off..."*
- Offer pills change to festival deals
- Dark golden theme activates
- Diwali sparkles animate across the page

**Say to the room:** *"That change we just made — in a real company, the marketing team updates one secret, one developer pushes one line, and the Diwali theme is live across thousands of servers. Zero manual SSH. Zero downtime. Zero human error."*

---

## Theme Options

| Secret value | Festival | Visual change |
|---|---|---|
| `default` | None | Standard Swiggy orange theme |
| `diwali` | Diwali | Dark golden, sparkles, festival banner + offers |
| `christmas` | Christmas | Red & green, Santa banner, winter offers |
| `holi` | Holi | Multicolour gradient banner, festival platters |

---

## GitHub Secrets Required

Set these in: **GitHub repo → Settings → Secrets and variables → Actions**

| Secret | Value | Purpose |
|---|---|---|
| `DOCKER_USERNAME` | Your Docker Hub username | Image registry login |
| `DOCKER_PASSWORD` | Your Docker Hub password | Image registry login |
| `EC2_HOST` | Your EC2 public IP | Where to deploy |
| `EC2_SSH_KEY` | Contents of your .pem file | SSH authentication |
| `ACTIVE_THEME` | `default` / `diwali` / `christmas` / `holi` | Controls festival theme |

---

## AWS EC2 Setup (do this the night before)

```bash
# 1. Launch t2.micro (Amazon Linux 2, free tier)
# 2. Open ports 22 and 80 in Security Group
# 3. SSH in and install Docker

ssh -i your-key.pem ec2-user@<EC2_IP>
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user
exit   # Re-login for group change to take effect

# 4. Verify
docker --version
curl http://localhost/health  # After first deploy
```

---

## Session Check-in Questions
Use these to pause and verify understanding:

1. *"Why does the Dockerfile have two stages?"*
   - Answer: Stage 1 injects the theme. Stage 2 is a lean nginx image. This is the multi-stage pattern.

2. *"What would happen if we hardcoded `ACTIVE_THEME=diwali` in the Dockerfile instead of using an ARG?"*
   - Answer: We'd have to rebuild and push the Dockerfile every time — defeating the purpose.

3. *"Why do we have a `needs: validate` in the build job?"*
   - Answer: So a broken HTML file never reaches production. The gate stops the pipeline early.
# first pipeline-run
Demo
